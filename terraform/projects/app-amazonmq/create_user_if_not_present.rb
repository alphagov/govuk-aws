#!/usr/bin/env/ruby

require 'net/http'
require 'json'

class RabbitMQAPI
  def initialize(
    root_url: ENV["API_ROOT_URL"], 
    username: ENV["API_USERNAME"], 
    password: ENV["API_PASSWORD"]
  )
    @root_url = root_url
    @username = username
    @password = password
  end

  def user_exists?(username)
    get!("/api/users/#{username}")
    true
  rescue RabbitMQAPIError => e
    (e.response.code.to_i == 404) ? false : raise
  end

  def create_user!(username, data)
    put!("/api/users/#{username}", data)
  end

  def get!(path)
    uri = URI(full_url(path))
    puts uri.to_s
    req = Net::HTTP::Get.new(uri)
    req.basic_auth(@username, @password)
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: (uri.scheme == 'https'), verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
      http.request(req)
    end
    handle_response!(response)
  end

  def put!(path, data={})
    uri = URI(full_url(path))
    puts uri.to_s
    req = Net::HTTP::Put.new(uri)
    req.basic_auth(@username, @password)
    req.body = data.to_json

    response = Net::HTTP.start(
      uri.hostname,
      uri.port,
      use_ssl: (uri.scheme == 'https'),
      verify_mode: OpenSSL::SSL::VERIFY_NONE,
      'Content-Type': 'application/json',
      ) do |http|
      http.request(req)
    end
    handle_response!(response)
  end

  def handle_response!(response, redirect_limit = 10)
    case response
      when Net::HTTPSuccess then
        response
      when Net::HTTPRedirection then
        location = response['location']
        warn "redirected to #{location}"
        get!(location, redirect_limit - 1)
      else
        raise RabbitMQAPIError.new(response)
    end
  end

  def full_url(path)
    URI.join(@root_url, path)
  end
end

class RabbitMQAPIError < RuntimeError
  attr_accessor :response

  def initialize(response)
    @response = response
    super
  end
end


def usage
  puts <<-END

Usage
-----

ruby create_user_if_not_present.rb 

Parameters
----------

The following environment variables are REQUIRED:

API_ROOT_URL=<string>
API_USERNAME=<string>
API_PASSWORD=<string>
USERS=<json packet>

USERS should be a json-encoded map in the format used in govuk-aws-data/data/app-amazonmq/(environment)/common.secret.tfvars:
  {
    'username1': { 'password': '...' },
    'username2': { 'password': '...' },
  }

  
  END
  exit 0
end

def check_env_vars_present!
  %w[API_ROOT_URL API_USERNAME API_PASSWORD USERS].each do |var|
    puts "ENV[#{var}]=#{ENV[var]}"
    usage if ENV[var].to_s.empty?
  end
end



def run!
  check_env_vars_present!
  api = RabbitMQAPI.new
  users = JSON.parse(ENV["USERS"])

  users.reject{|key, value| key == 'root'}.each do |username, attributes|
    puts "checking for existing user #{username}"
    if api.user_exists?(username)
      puts "\t=> exists"
    else
      puts "\t=> does not exist. Creating..."
      begin
        api.create_user!(username, attributes.merge( "tags" => "management" ))
        puts "\t   created."
      rescue RabbitMQAPIError => e
        puts "\t   FAILED. Code #{e.response.code} - \n#{e.response.body}"
      end
    end
  end
end

run!
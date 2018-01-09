#!/usr/bin/env ruby

require 'colorize'

class ValidateResources
  def validate_resource_name(file, resource_name, rule, options = {})
    abort("Cannot find #{file}") unless File.exist?(file)

    @failed_resources = []
    File.open(file).readlines.each do |line|
      line.chomp!

      puts " -- processing [#{line}]" if options[:debug]
      next unless line.match(/\s*resource\s+"#{resource_name}"/)

      m = line.match(/\s*resource\s+"#{resource_name}"\s+"#{rule}"/)
      resource = line.match(/\s*resource\s+"#{resource_name}"\s+"(?<name>.+)"/)

      if m.nil?
        @failed_resources << resource[:name]
      else
        puts "Matched #{line}" if options[:matched]
      end
    end

    if @failed_resources.empty?
      return {}
    else
      { resource_name => @failed_resources }
    end
  end

  def run(directory, resource, rule, options = {})
    abort("Cannot find #{directory}") unless Dir.exist?(directory)
    $errors = []

    Dir["#{directory}/**/*.tf"].each do |file|
      puts "Working on [#{file}]" if options[:verbose]

      file_status = validate_resource_name(file, resource, rule, options)

      unless file_status.empty?
        puts "#{file} failed on #{rule}:"
        file_status.each do |key, val|
          if options[:colours]
            puts "  Resource #{key.colorize(:red)}"
          else
            puts "  Resource #{key}"
          end
          val.each do |r|
            if options[:colours]
              puts "    #{r.colorize(:yellow)}"
            else
              puts "    #{r}"
            end
          end
        end
      $errors << false
      end
    end

    $errors.include?(false) ? 'false' : 'true'
  end
end

#!/usr/bin/env ruby

require_relative 'validate_resources'
require 'yaml'

resources = YAML.load_file('lint.yaml')['resources']

options = {
#  :verbose => true,
#  :debug => true,
#  :matched => true,
#  :colours => true,
}

$errors = []

resources.each do |key, val|
  val.each do |v|
    $errors << ValidateResources.new.run(File.expand_path('terraform'), key, v, options)
  end
end

exit 1 if $errors.include?(false)

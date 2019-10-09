#!/usr/bin/env ruby

require 'optparse'

USAGE_BANNER = 'Usage: bulk-plan.rb ENVIRONMENT GLOBS ...'

def parse_options
  options = {}

  @option_parser = OptionParser.new do |opts|
    opts.banner = USAGE_BANNER

    opts.on('-v', '--verbose', 'Enable more detailed logging') do
      $verbose = true
    end
    opts.on('-d', '--dry-run', 'Just print what would be done') do
      options[:dry_run] = true
    end

    opts.on('-h', '--help', 'Prints usage information and examples') do
      # TODO
      exit
    end
  end

  @option_parser.parse!

  options
end

def bulk_plan(environment, globs, dry_run: false)
  files = globs.flat_map do |glob|
    Dir.glob(glob, base: 'terraform/projects')
  end

  projects_and_stacks = {}

  files.sort.each do |project|
    backend_filename_parts = Dir.glob(
      "*.backend",
      base: "terraform/projects/#{project}"
    ).map { |backend_filename| backend_filename.split(".") }


    relevant_backend_files = backend_filename_parts.select do |parts|
      parts[0] == environment
    end

    stacks = relevant_backend_files.map do |parts|
      parts[1]
    end

    projects_and_stacks[project] = { stacks: stacks }
  end

  puts "Matched projects, with no relevant stacks:"
  projects_and_stacks.each do |project, data|
    next unless data[:stacks].empty?

    puts " - #{project}"
  end
  puts

  puts "Matched projects, with stacks:"
  projects_and_stacks.each do |project, data|
    next if data[:stacks].empty?

    if data[:stacks].length == 1
      puts " - #{project.ljust(40)}#{data[:stacks][0]}"
    else
      puts " - #{project}"
      data[:stacks].each do |stack|
        puts "   - #{stack}"
      end
    end
  end
  puts

  projects_and_stacks.each do |project, data|
    next if data[:stacks].empty?

    data[:stacks].each do |stack|
      command = [
        "ruby",
        "tools/deploy.rb",
        stack,
        project,
        environment,
        "plan",
      ]

      if dry_run
        puts "would run: #{command.join(' ')}"
      else
        puts "running: #{command.join(' ')}"

        command_succeeded = system(*command)

        unless command_succeeded
          puts "command failed"

          exit 1
        end
      end
    end
  end
end

def main
  options = parse_options

  environment, *globs = *ARGV

  unless environment
    puts "error: you must specify the environment"
    puts
    puts @option_parser.help
    exit 1
  end

  unless globs
    puts "error: you must specify the projects glob"
    puts
    puts @option_parser.help
    exit 1
  end

  bulk_plan(environment, globs, dry_run: options[:dry_run])
end

main

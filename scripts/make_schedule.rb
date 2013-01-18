#!/usr/bin/env ruby

require 'erb'
require 'date'
require 'yaml'

@first_monday = Date.new(2013,1,14)

script_file = File.expand_path($0)
scripts_dir = File.dirname(script_file)
schedule_file = File.join(scripts_dir, "schedule.yaml")
template_file = File.join(scripts_dir, "schedule.html.erb")
output_file = File.expand_path(File.join(scripts_dir,
  "../includes/schedule.html"))

@schedule = File.open(schedule_file) do |f| YAML.load(f) end
template = File.open(template_file) do |f| ERB.new(f.read) end

def label(evt)
  "<span class=\"label\">" + evt["type"] +
    "</span>" if evt["type"] == "recitation"
end

def topic(evt)
  if evt["type"] == "lecture" || evt["type"] == "midterm"
    "<strong>" + evt["topic"] + "</strong>"
  else
    evt["topic"]
  end
end

@day = @first_monday - 1
DAYS = ["U","M","T","W","R","F","S"]
File.open(output_file, "w") do |file|
  file.puts(template.result(binding))
end
puts "\n******************************************\n" +
       "Done! Please commit and push your changes,\n" +
       "or print them out and fax them to Vincent.\n" +
       "******************************************"

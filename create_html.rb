require 'erb'
require 'json'

class HtmlBuilder
  def json
    parsed_json = JSON.parse("{}")
    parsed_json.to_json
  end
  def get_binding # this is only a helper method to access the objects binding method
    binding
  end

  def build
  	@json = json
	file = File.open("/Users/praveena/projects/damsel_in_distress/chart.html.erb", "rb")
	template_string = file.read
	template = ERB.new template_string 
	template.result(get_binding)
  end
end

builder = HtmlBuilder.new

puts builder.build

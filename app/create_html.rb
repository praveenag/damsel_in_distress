require './workspace'
require 'json'

class HtmlBuilder
  def json
    parsed_json = JSON.parse("{\"label\": [\"Male\", \"Female\"], \"values\": [\n    {\n        \"label\": \"11...100\",\n        \"values\": [40, 0]\n    },\n    {\n        \"label\": \"9...11\",\n        \"values\": [28, 2]\n    },\n    {\n        \"label\": \"7...9\",\n        \"values\": [50, 7]\n    },\n    {\n        \"label\": \"5...7\",\n        \"values\": [44, 8]\n    },\n    {\n        \"label\": \"3...5\",\n        \"values\": [41, 13]\n    },\n    {\n        \"label\": \"0...3\",\n        \"values\": [77, 70]\n    }\n]}")
    parsed_json.to_json
  end

  def get_binding # this is only a helper method to access the objects binding method
    binding
  end

  def build
    @json = json
    file = File.open("#{app_dir}/chart.html.erb", "rb")
    template_string = file.read
    template = ERB.new template_string
    template.result(get_binding)
  end
end

builder = HtmlBuilder.new

puts builder.build

require './workspace'
require 'json'

class HtmlBuilder
  def get_binding # this is only a helper method to access the objects binding method
    binding
  end

  def html(json)
    @json = json
    file = File.open("#{app_dir}/chart.html.erb", "rb")
    template_string = file.read
    template = ERB.new template_string
    template.result(get_binding)
  end

  def create_html(json, file)
    write_to_file(file, html(json))
  end
end

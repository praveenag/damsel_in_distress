require './workspace'
require 'json'

class HtmlBuilder
  def get_binding # this is only a helper method to access the objects binding method
    binding
  end

  def html(json, template)
    @json = json
    file = File.open(template, "rb")
    template_string = file.read
    template = ERB.new template_string
    template.result(get_binding)
  end

  def create_html(json, file, template)
    write_to_file(file, html(json, template))
  end
end

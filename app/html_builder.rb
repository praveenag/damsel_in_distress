require './workspace'
require 'json'

class HtmlBuilder
  def get_binding # this is only a helper method to access the objects binding method
    binding
  end

  def create_html(json, file, template, role = nil, exp_range = nil, males = nil, females = nil)
    write_to_file(file, html(json, template, role, exp_range, males, females))
  end

  private

  def html(json, template, role, exp_range, males, females)
    @json = json
    @role = role
    @exp_range = exp_range
    @males = males
    @females = females
    file = File.open(template, "rb")
    template_string = file.read
    template = ERB.new template_string
    template.result(get_binding)
  end
end

require './workspace'
require './parser'
require './analyser'
require './html_builder'

class Orchestrator
  def initialize(parser)
    @analyser = Analyser.new
    @html_builder = HtmlBuilder.new
    @parser = parser
  end

  def role_wise_split
    grouped_by_sex = @analyser.group_by_sex(@parser.rows)
    role_to_gender_count = @analyser.role_to_gender_count(grouped_by_sex)
    constructed_json = @analyser.chart_json(role_to_gender_count)
    write_to_file("#{gen_dir}/role_wise_split.json", constructed_json)
  end

  def role_to_gender_to_exp
    grouped_by_sex = @analyser.group_by_sex(@parser.rows)
    role_to_gender = @analyser.role_to_gender(grouped_by_sex)

    role_to_gender.each do |role, data|
      data1 = @analyser.gender_count_for_a_role(data, role)
      @html_builder.create_html(@analyser.chart_json(data1), "#{gen_dir}/#{role.to_s}.html")
    end
  end

end

parser = Parser.new
parser.parse()

orchestrator = Orchestrator.new(parser)
orchestrator.role_wise_split
orchestrator.role_to_gender_to_exp

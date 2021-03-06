require '../app/workspace'
require '../app/parser'
require '../app/analyser'
require '../app/html_builder'
require '../app/json_builder'

class Orchestrator
  def initialize(parser)
    @analyser = Analyser.new
    @html_builder = HtmlBuilder.new
    @json_builder = JsonBuilder.new
    @parser = parser
  end

  def role_wise_split
    constructed_json = @json_builder.chart_json(role_to_gender_count)
    FileUtils.mkdir_p(File.join(role_gen), :verbose => true)
    @html_builder.create_html(constructed_json, "#{role_gen}/role_wise_split.html", role_exp_template)
  end

  def role_to_gender_to_exp
    grouped_by_sex = @analyser.group_by_sex(@parser.rows)
    role_to_gender = @analyser.role_to_sex(grouped_by_sex)

    role_to_gender.each do |role, data|
      exp_range_split_data = @analyser.gender_count_for_a_role_exp_range(data, role)
      FileUtils.mkdir_p(File.join(role_gen), :verbose => true)
      html = "#{role_gen}/#{role.to_s}.html"
      @html_builder.create_html(@json_builder.chart_json(exp_range_split_data), html, role_exp_template, role, nil,
                                role_to_gender_count[role][0], role_to_gender_count[role][1])
    end
  end

  def role_to_gender_to_exp_to_grade
    #not used
    grouped_by_sex = @analyser.group_by_sex(@parser.rows)
    role_to_gender = @analyser.role_to_sex(grouped_by_sex)

    role_to_gender.each do |role, data|
      exp_range_split_data = @analyser.role_to_exp_range_sex(data)
      exp_range_split_data.each do |exp_range, data1|
        grade_split_data = @analyser.gender_percentile_for_a_role_exp_range_grade(data1, exp_range)
        FileUtils.mkdir_p(exp_gen(role), :verbose => true)
        @html_builder.create_html(@json_builder.chart_json(grade_split_data),
                                  "#{exp_gen(role)}/#{exp_range.to_s}.html", role_exp_grade_template, role, exp_range,
                                  exp_range_split_data[exp_range][:m].size, exp_range_split_data[exp_range][:f].size)
      end
    end
  end

  def grade_count_for_a_role_exp_range_gender
    grouped_by_sex = @analyser.group_by_sex(@parser.rows)
    role_to_gender = @analyser.role_to_sex(grouped_by_sex)

    role_to_gender.each do |role, data|
      exp_range_split_data = @analyser.role_to_exp_range_sex(data)
      exp_range_split_data.each do |exp_range, data1|
        grade_split_data = @analyser.grade_count_for_a_role_exp_range_gender(data1, exp_range)
        FileUtils.mkdir_p(grade_gen(role), :verbose => true)
        html = "#{grade_gen(role)}/#{exp_range.to_s}.html"
        @html_builder.create_html(grade_split_data,
                                  html, role_exp_grade_template,
                                  role, exp_range)
        #figure out a way to give male female no data since this s all but json
      end
    end
  end

  private

  def role_to_gender_count
    grouped_by_sex = @analyser.group_by_sex(@parser.rows)
    @analyser.role_to_sex_count(grouped_by_sex)
  end
end

parser = Parser.new
parser.parse()

orchestrator = Orchestrator.new(parser)

orchestrator.role_wise_split
orchestrator.role_to_gender_to_exp
orchestrator.role_to_gender_to_exp_to_grade
orchestrator.grade_count_for_a_role_exp_range_gender
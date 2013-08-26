require './workspace'
require './parser'
require './analyser'

parser = Parser.new
parser.parse()

analyser = Analyser.new
grouped_by_sex = analyser.group_by_sex(parser.rows)

role_to_gender_count = analyser.role_to_gender_count(grouped_by_sex)
constructed_json = analyser.chart_json(role_to_gender_count)
write_to_file("#{gen_dir}/role_wise_split.json", constructed_json)

role_to_gender = analyser.role_to_gender(grouped_by_sex)

role_to_gender.each do |role, data|
  data1 = analyser.gender_count_for_a_role(data, role)
  write_to_file("#{gen_dir}/#{role.to_s}.json", analyser.chart_json(data1))
end
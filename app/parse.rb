require './workspace'

class Parser

  attr_accessor :rows

  def parse
    rows = []
    CSV.foreach(data_path) do |row|
      rows << Row.new(row)
    end
    @rows = rows
  end
end

class Analyser

  def group_by_sex(slice)
    slice.group_by { |row| row.sex.downcase.to_sym }
  end

  def group_by_roles(slice)
    slice.group_by { |row| row.title.downcase.to_sym }
  end

  def role_to_gender_count(data)
    males = group_by_roles(data[:m])
    females = group_by_roles(data[:f])
    roles = males.keys.concat(females.keys).uniq
    return_val = {}
    roles.each { |role| return_val[role] = [males[role].to_a.count, females[role].to_a.count] }
    return_val
  end

  def role_to_gender(data)
    males = group_by_roles(data[:m])
    females = group_by_roles(data[:f])
    roles = males.keys.concat(females.keys).uniq
    return_val = {}
    roles.each { |role| return_val[role] = {:m => males[role], :f => females[role]} }
    return_val
  end

  def chart_json(data)
    return_val = {}
    label = ["Male", "Female"]
    values = []
    data.each { |role, value| values << {'label' => role, 'values' => value} }
    return_val['label'] = label
    return_val['values'] = values
    return_val.to_json
  end

  def group_by_experience(slice)
    ranges = [Range.new(0, 3, true), Range.new(3, 5, true), Range.new(5, 7, true), Range.new(7, 9, true), Range.new(9, 11, true), Range.new(11, 100, true)]
    slice.group_by { |row| ranges.find { |range| b = range.cover?(row.total_exp.to_f); p b; b } }
  end

  def gender_count_for_a_role(data, role)

    p "nil m #{role}" if data[:m].nil?
    p "nil f #{role}" if data[:f].nil?
    return_val = {}

    if data[:m].nil?
      if data[:f].nil?
        return {:"no role" => [0, 0]}
      else
        females = group_by_experience(data[:f])
        exp_ranges = females.keys
        exp_ranges.each { |exp_range| return_val[exp_range] = [0, females[exp_range].to_a.count] }
        return return_val
      end
    elsif data[:f].nil?
      males = group_by_experience(data[:m])
      exp_ranges = males.keys
      exp_ranges.each { |exp_range| return_val[exp_range] = [males[exp_range].to_a.count, 0] }
      return return_val
    else
      males = group_by_experience(data[:m])
      females = group_by_experience(data[:f])
      exp_ranges = males.keys.concat(females.keys).uniq
      exp_ranges.each { |exp_range| return_val[exp_range] = [males[exp_range].to_a.count, females[exp_range].to_a.count] }
      return return_val
    end
  end

  def chart_json_by_experience(data)
    return_val = {}
    label = ["0-3", "3-5", "5-7", "7-9", "9-11", ">11"]
    values = []
    data.each do |range, value|
      values << {'label' => range.to_s, 'values' => value}
    end
    return_val['label'] = label
    return_val['values'] = values
    return_val.to_json
  end

end

class Row

  attr_accessor :name, :official_title, :title, :first_day, :sex, :office, :prior_exp, :tw_exp, :exp_in_contract, :total_exp

  def initialize(row)
    @name, @official_title, @title, @first_day, @sex, @office, @prior_exp, @tw_exp, @exp_in_contract, @total_exp = sanitize(row)
  end

  def sanitize(row)
    row.to_a.collect { |r| r.nil? ? "" : r.chomp(" ") }
  end

  def exp_as_date
    Date.strptime(total_exp, "%d %b %y")
  end
end

def write_to_file(filename, data)
  File.open(filename, 'a') { |file| file.write(data) }
end

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
require 'csv'
require 'json'

$root_dir = "/Users/Praveena/projects/damsel_in_distress"
$path = "#{$root_dir}/data_back.csv"

class Parser

  attr_accessor :rows

  def parse
    rows = [] 
    CSV.foreach($path) do |row|
      rows << Row.new(row)
    end
    @rows = rows
  end
end

class Analyser

  attr_accessor :grouped
  
  def group_by_sex(slice)
    grouped = slice.group_by {|row| row.sex.downcase.to_sym}
    p grouped[:m].count
    p grouped[:f].count
    #p slice.count
    #p grouped.keys
    @grouped = grouped
  end

  def group_by_roles(slice)
    slice.group_by {|row| row.title.downcase.to_sym}
  end

  def call_to_json(slice, path)
    slice.to_json
  end

  def form_json(data)
    males = group_by_roles(data[:m])
    females = group_by_roles(data[:f])
    roles = males.keys.concat(females.keys).uniq
    return_val = {}
    roles.each do |role|
      return_val[role] = [males[role].to_a.count, females[role].to_a.count]
    end
    return_val
  end

  def chart_json(data)
    return_val = {}
    label = ["Male", "Female"]
    values = []
    data.each do |role, value|
      values << { 'label' => role, 'values' => value}
    end
    return_val['label'] = label    
    return_val['values'] = values
    return_val.to_json
  end

end

class Row
  
  attr_accessor :name, :title, :first_day, :sex, :office, :prior_exp, :tw_exp, :exp_in_contract, :total_exp

  def initialize(row)
    @name,@title,@first_day,@sex,@office,@prior_exp,@tw_exp,@exp_in_contract,@total_exp = sanitize(row)
  end

  def sanitize(row)
    row.to_a.collect{|r| r.nil? ? "" : r.chomp(" ")}
  end
end

def write_to_file(data)
  File.open("/Users/praveena/projects/damsel_in_distress/a.json", 'a') { |file| file.write(data) }
end

parser = Parser.new
parser.parse()

analyser = Analyser.new
analyser.group_by_sex(parser.rows)
role_to_gender = analyser.form_json(analyser.grouped)
constructed_json = analyser.chart_json(role_to_gender)
write_to_file(constructed_json)

#s1 = analyser.group_by_roles(analyser.grouped[:m])
#s2 = analyser.group_by_roles(analyser.grouped[:f])

require 'csv'
require 'json'

$root_dir = "/Users/Praveena/projects/damsel_in_distress"
$path = "#{$root_dir}/data.csv"

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
    p slice.count
    p grouped.keys
    @grouped = grouped
  end

  def group_by_roles(slice)
    grouped = slice.group_by {|row| row.title.downcase.to_sym}
    p grouped.keys
    grouped
  end

  def call_to_json(slice, path)
    slice.to_json
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

parser = Parser.new
parser.parse()

analyser = Analyser.new
analyser.group_by_sex(parser.rows)
s1 = analyser.group_by_roles(analyser.grouped[:m])
s2 = analyser.group_by_roles(analyser.grouped[:f])
File.open("/Users/praveena/projects/damsel_in_distress/a.json", 'w') { |file| file.write(s1.to_json) }
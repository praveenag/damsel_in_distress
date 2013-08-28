require './workspace'

class JigsawRow

  #attr_accessor :emp_id, :name, :sex, :role, :grade, :region, :home_office, :total_exp, :tw_exp
  attr_accessor :emp_id, :name, :sex, :title, :grade, :region, :home_office, :total_exp, :tw_exp

  def initialize(row)
    @emp_id, @name, @sex, @title, @grade, @region, @home_office, @total_exp, @tw_exp = sanitize(row)
  end

  def sanitize(row)
    row.to_a.collect { |r| r.nil? ? "" : r.chomp(" ") }
  end

  def sex
    @sex.downcase == "male" ? "m" : "f"
  end

  def exp_as_date
    Date.strptime(total_exp, "%d %b %y")
  end
end
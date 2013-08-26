require './workspace'

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
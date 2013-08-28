require './workspace'

class Analyser

  def group_by_sex(slice)
    slice.group_by { |row| row.sex.downcase.to_sym }
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
        exp_ranges.each { |exp_range| return_val[exp_range] = percentile(0, females[exp_range].to_a.count) }
        return return_val
      end
    elsif data[:f].nil?
      males = group_by_experience(data[:m])
      exp_ranges = males.keys
      exp_ranges.each { |exp_range| return_val[exp_range] = percentile(males[exp_range].to_a.count, 0) }
      return_val
    else
      males = group_by_experience(data[:m])
      females = group_by_experience(data[:f])
      exp_ranges = males.keys.concat(females.keys).uniq
      exp_ranges.each { |exp_range| return_val[exp_range] = percentile(males[exp_range].to_a.count, females[exp_range].to_a.count) }
      return_val
    end
  end

  def gender_count_for_a_role_2yrs(data, role)

    p "nil m #{role}" if data[:m].nil?
    p "nil f #{role}" if data[:f].nil?
    return_val = {}

    if data[:m].nil?
      if data[:f].nil?
        return {:"no role" => [0, 0]}
      else
        females = group_by_experience(data[:f])
        exp_ranges = females.keys
        exp_ranges.each { |exp_range| return_val[exp_range] = percentile(0, females[exp_range].to_a.count) }
        return return_val
      end
    elsif data[:f].nil?
      males = group_by_experience(data[:m])
      exp_ranges = males.keys
      exp_ranges.each { |exp_range| return_val[exp_range] = percentile(males[exp_range].to_a.count, 0) }
      return_val
    else
      males = group_by_experience(data[:m])
      females = group_by_experience(data[:f])
      exp_ranges = males.keys.concat(females.keys).uniq
      exp_ranges.each { |exp_range| return_val[exp_range] = percentile(males[exp_range].to_a.count, females[exp_range].to_a.count) }
      return_val
    end
  end

  private

  def percentile(val1, val2)
    sum = 100/(val1+val2).to_f
    [(val1*sum.to_f).round(2), (val2*sum.to_f).round(2)]
  end

  def group_by_roles(slice)
    slice.group_by { |row| row.title.downcase.to_sym }
  end

  def group_by_experience(slice)
    ranges = [Range.new(0, 3, true), Range.new(3, 5, true), Range.new(5, 7, true), Range.new(7, 9, true), Range.new(9, 11, true), Range.new(11, 100, true)]
    slice.group_by { |row| ranges.find { |range| b = range.cover?(row.total_exp.to_f); p b; b } }
  end
end
require './workspace'
require '../app/range'

class Analyser

  def group_by_sex(slice)
    slice.group_by { |row| row.sex.downcase.to_sym }
  end

  def role_to_sex_count(data)
    males = group_by_roles(data[:m])
    females = group_by_roles(data[:f])
    roles = males.keys.concat(females.keys).uniq
    return_val = {}
    roles.each { |role| return_val[role] = [males[role].to_a.count, females[role].to_a.count] }
    return_val
  end

  def role_to_sex(data)
    males = group_by_roles(data[:m])
    females = group_by_roles(data[:f])
    roles = males.keys.concat(females.keys).uniq
    return_val = {}
    roles.each { |role| return_val[role] = {:m => males[role], :f => females[role]} }
    return_val
  end

  def gender_count_for_a_role_exp_range(data, role)

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
        #exp_ranges.each { |exp_range| return_val[exp_range] = percentile_by_total(0, females[exp_range].to_a.count) }
        sorted_hash(return_val)
      end
    elsif data[:f].nil?
      males = group_by_experience(data[:m])
      exp_ranges = males.keys
      exp_ranges.each { |exp_range| return_val[exp_range] = percentile(males[exp_range].to_a.count, 0) }
      #exp_ranges.each { |exp_range| return_val[exp_range] = percentile_by_total(males[exp_range].to_a.count, 0) }
      sorted_hash(return_val)
    else
      males = group_by_experience(data[:m])
      females = group_by_experience(data[:f])
      exp_ranges = males.keys.concat(females.keys).uniq
      exp_ranges.each { |exp_range| return_val[exp_range] = percentile(males[exp_range].to_a.count, females[exp_range].to_a.count) }
      #exp_ranges.each { |exp_range| return_val[exp_range] = percentile_by_total(males[exp_range].to_a.count, females[exp_range].to_a.count) }
      sorted_hash(return_val)
    end
  end

  def grade_count_for_a_role_exp_range_gender(data, exp_range)
    return_val = gender_count_for_a_role_exp_range_grade(data, exp_range)
    males_arr = []
    females_arr = []
    labels = []

    return_val.each do |grade, m_f_array|
      labels << grade
      males_arr << m_f_array[0]
      females_arr << m_f_array[1]
    end
    json = {}
    p labels
    p percentile_in_arr(males_arr)
    p percentile_in_arr(females_arr)

    json['label'] = labels
    json['values'] = [{'label' => 'male', 'values' => percentile_in_arr(males_arr)}, {'label' => 'female', 'values' => percentile_in_arr(females_arr)}]
    json.to_json
  end


  def gender_percentile_for_a_role_exp_range_grade(data, exp_range)
    p "nil m #{exp_range}" if data[:m].nil?
    p "nil f #{exp_range}" if data[:f].nil?
    return_val = {}

    if data[:m].nil?
      if data[:f].nil?
        return {:"no role" => [0, 0]}
      else
        females = group_by_grade(data[:f])
        grades = females.keys
        grades.each { |grade| return_val[grade] = percentile_by_total(0, females[grade].to_a.count) }
        #grades.each { |grade| return_val[grade] = percentile_by_sex(0, females[grade].to_a.count, 0, data[:f].count) }
        sorted_hash(return_val)
      end
    elsif data[:f].nil?
      males = group_by_grade(data[:m])
      grades = males.keys
      grades.each { |grade| return_val[grade] = percentile_by_total(males[grade].to_a.count, 0) }
      #grades.each { |grade| return_val[grade] = percentile_by_sex(males[grade].to_a.count, 0, data[:m].count, 0) }
      sorted_hash(return_val)
    else
      males = group_by_grade(data[:m])
      females = group_by_grade(data[:f])
      grades = males.keys.concat(females.keys).uniq
      grades.each { |grade| return_val[grade] = percentile_by_total(males[grade].to_a.count, females[grade].to_a.count) }
      #grades.each { |grade| return_val[grade] = percentile_by_sex(males[grade].to_a.count, females[grade].to_a.count, data[:m].count, data[:f].count) }
      sorted_hash(return_val)
    end
  end

  def gender_count_for_a_role_exp_range_grade(data, exp_range)
    p "nil m #{exp_range}" if data[:m].nil?
    p "nil f #{exp_range}" if data[:f].nil?
    return_val = {}

    if data[:m].nil?
      if data[:f].nil?
        return {:"no role" => [0, 0]}
      else
        females = group_by_grade(data[:f])
        grades = females.keys
        grades.each { |grade| return_val[grade] = percentile(0, females[grade].to_a.count) }
        sorted_hash(return_val)
      end
    elsif data[:f].nil?
      males = group_by_grade(data[:m])
      grades = males.keys
      grades.each { |grade| return_val[grade] = percentile(males[grade].to_a.count, 0) }
      sorted_hash(return_val)
    else
      males = group_by_grade(data[:m])
      females = group_by_grade(data[:f])
      grades = males.keys.concat(females.keys).uniq
      grades.each { |grade| return_val[grade] = percentile(males[grade].to_a.count, females[grade].to_a.count) }
      sorted_hash(return_val)
    end
  end


  def role_to_exp_range_sex(data)
    xdata = {}
    xdata[:m] = data[:m].nil? ? [] : data[:m]
    xdata[:f] = data[:f].nil? ? [] : data[:f]
    return_val = {}

    males = group_by_experience(xdata[:m])
    females = group_by_experience(xdata[:f])

    exp_ranges = males.keys.concat(females.keys).uniq
    exp_ranges.each { |exp_range| return_val[exp_range] = {:m => males[exp_range].to_a, :f => females[exp_range].to_a} }
    sorted_hash(return_val)
  end

  private

  def sorted_hash(hash = {})
    sortedKeys = hash.keys.sort
    new_hash = {}
    sortedKeys.each {|key| new_hash[key] = hash[key]}
    new_hash
  end

  def percentile_in_arr(arr)
    sum = arr.inject(&:+)
    arr.collect {|a| a == 0 ? 0 : (a*100/sum.to_f).round(2)}
  end

  def percentile(male, female)
    [male, female]
  end

  def percentile_by_total(male, female)
    sum = 100/(male+female).to_f
    [(male*sum.to_f).round(2), (female*sum.to_f).round(2)]
  end

  def percentile_by_sex(male, female, tot_male, tot_female)
    male_count = tot_male == 0 ? 0 : (male*100/tot_male.to_f).round(2)
    female_count = tot_female == 0 ? 0 : (female*100/tot_female.to_f).round(2)
    [male_count, female_count]
  end

  def group_by_roles(slice)
    slice.group_by { |row| row.title.downcase.to_sym }
  end

  def group_by_experience(slice)
    ranges = [Range.new(0, 3, true), Range.new(3, 5, true), Range.new(5, 7, true), Range.new(7, 9, true), Range.new(9, 11, true), Range.new(11, 100, true)]
    slice.group_by { |row| ranges.find { |range| range.cover?(row.total_exp.to_f) } }
  end

  def group_by_grade(slice)
    slice.group_by { |row| row.grade.downcase.to_sym }
  end
end
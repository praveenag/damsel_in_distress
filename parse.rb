require 'csv'
$root_dir = "/Users/Praveena/projects/damsel_in_distress"
$path = "#{$root_dir}/data.csv"

def parse 
  CSV.foreach($path) do |row|
    name,title,first_day,sex,office,prior_exp,tw_exp,exp_in_contract,total_exp = row
  end
end

require 'erb'
require 'json'
require 'csv'
require 'fileutils'

def root_dir
  "/Users/Praveena/projects/damsel_in_distress"
end

def gen_dir
  "#{root_dir}/gen"
end

def lib_dir
  "#{root_dir}/lib"
end

def app_dir
  "#{root_dir}/app"
end

def data_path
  "#{root_dir}/jigsaw.csv"
  #"#{root_dir}/data_back.csv"
end

def role_exp_template
  "#{app_dir}/chart.html.erb"
end

def role_exp_grade_template
  "#{app_dir}/chart_final.html.erb"
end

def write_to_file(filename, data)
  File.open(filename, 'w') { |file| file.write(data) }
end

def append_to_file(filename, data)
  File.open(filename, 'a') { |file| file.write(data) }
end

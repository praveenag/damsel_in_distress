require 'erb'
require 'json'
require 'csv'

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
  "#{root_dir}/data_back.csv"
end

def write_to_file(filename, data)
  File.open(filename, 'w') { |file| file.write(data) }
end

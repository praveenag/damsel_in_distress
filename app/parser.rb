require './workspace'
require './row'

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
require '../app/workspace'
require '../app/jigsaw_row'

class Parser

  attr_accessor :rows

  def parse
    rows = []
    CSV.open(data_path).drop(1).each do |row|
      rows << JigsawRow.new(row)
    end
    @rows = rows
  end
end
class Range
  def <=>(other)
    [min, max] <=> [other.min, other.max]
  end
end
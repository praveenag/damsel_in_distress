class Range
  def <=>(other)
    [min, max] <=> [other.min, other.max]
  end

  def to_s
    "#{min} to #{max}"
  end
end
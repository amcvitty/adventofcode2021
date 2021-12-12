require "set"

List = Struct.new(:hd, :tail) do
  def cons(h)
    List.new(h, self)
  end

  def length
    if tail.nil?
      1
    else
      1 + tail.length()
    end
  end

  def include?(i)
    if hd == i
      return true
    elsif tail.nil?
      false
    else
      tail.include?(i)
    end
  end

  # Returns it in reverse order...
  def to_a
    if tail == nil
      [hd]
    else
      tail.to_a << hd
    end
  end
end

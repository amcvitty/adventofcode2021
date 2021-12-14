Rule = Struct.new(:pair, :ins) do
  def inspect
    "#{pair} => #{ins}"
  end
end

def to_hashcount(str)
  pairs = {}
  (0..str.length - 2).each { |i|
    pair = str[i, 2]
    if pairs[pair]
      pairs[pair] += 1
    else
      pairs[pair] = 1
    end
  }
  pairs
end

def apply(template, rules)
  insertions = Array.new(template.length, nil)
  (0..template.length - 2).each do |i|
    rules.each do |rule|
      if template[i, 2] == rule.pair
        insertions[i] = rule.ins
      end
    end
  end
  t2 = ""
  (0..template.length - 1).each do |i|
    t2 << template[i]
    t2 << insertions[i] if !insertions[i].nil?
  end
  t2
end

def score(template)
  all = template.chars.group_by(&:itself).values.map(&:size).sort
  all.max - all.min
end

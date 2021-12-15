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

def applyn(template, rules, n)
  n.times do
    template = apply(template, rules)
  end
  template
end

def apply(template, rules)
  t2 = {}
  template.each do |pair, freq|
    ins = rules[pair]
    if ins.nil?
      add_to_key(t2, pair, freq)
    else
      add_to_key(t2, pair.chars[0] + ins, freq)
      add_to_key(t2, ins + pair.chars[1], freq)
    end
  end
  t2
end

def add_to_key(hash, k, v)
  if hash[k]
    hash[k] += v
  else
    hash[k] = v
  end
end

def apply1(template, rules)
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
  letter_frequencies = {}
  template.each { |pair, f|
    add_to_key(letter_frequencies, pair[0], f)
    add_to_key(letter_frequencies, pair[1], f)
  }
  letter_frequencies.delete("x")
  fs = letter_frequencies.values.map { |f| f / 2 }
  fs.max - fs.min
end

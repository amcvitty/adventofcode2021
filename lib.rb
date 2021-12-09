def originals
  ["abcefg",
   "cf",
   "acdeg",
   "acdfg",
   "bcdf",
   "abdfg",
   "abdefg",
   "acf",
   "abcdefg",
   "abcdfg"]
end

def sort_string(s)
  s.chars.sort.join("")
end

def permute_string(str)
  permute(str.chars).map { |x| x.join "" }
end

def permute(arr)
  if arr.size == 1
    return [arr]
  end
  ret = []
  arr.each do |a|
    permute(arr.filter { |x| x != a }).each do |rest|
      ret << [a].concat(rest)
    end
  end
  ret
end

def decode_line(line)
  permutations = permute_string("abcdefg")
  decode_line_precalced(line, permutations)
end

def decode_line_precalced(line, permutations)
  (digits, display) = line.split("|")
  digits = digits.split(" ")
  display = display.split(" ")

  i = 0
  until permutation_solves(permutations[i], digits)
    i += 1
  end

  ret = display.map { |n|
    originals.find_index(
      sort_string translate(permutations[i], n)
    )
  }.join.to_i

  print display.join(" "), ": ", ret
  puts
  ret
end

# permutation is an ordering of the fake stuff that lines up with real abcdefg
def permutation_solves(permutation, digits)
  digits.all? { |digit|
    originals.include?(sort_string translate(permutation, digit))
  }
end

def translate(permutation, digit)
  digit.chars.map { |x|
    "abcdefg".chars[permutation.chars.find_index(x)]
  }.join ""
end

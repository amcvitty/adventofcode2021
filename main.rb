require_relative "lib.rb"

lines = $stdin.read.split("\n")

algo = ""
image = nil
lines.each do |line|
  if image.nil? # still processing algo
    if line == ""
      image = []
    else
      algo.concat line
    end
  else
    image << line.chars
  end
end

image = enlarge(image, 5, ".")
puts algo.size
puts image.size
puts image[0].size
draw(image)

50.times do |i|
  fillchar = i % 2 == 0 ? algo[0] : "."
  image = enhance(image, algo, fillchar)
  image = enlarge(image, 1, fillchar)

  draw(image)
  puts "----#{i + 1}----"
end
puts count_pixels(image)

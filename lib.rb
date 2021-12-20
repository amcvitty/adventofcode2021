require "matrix"
require "set"

def b_to_i(binary)
  i = 0
  binary.each do |c|
    i = (i << 1) + (c == "#" ? 1 : 0)
  end
  i
end

def enhance(image, algo, fillchar)
  rows = image.size
  cols = image[0].size
  newimage = []
  rows.times { |r|
    newrow = []
    cols.times { |c|
      if r == 0 || r == rows - 1 ||
         c == 0 || c == cols - 1
        newrow << fillchar
      else
        digits = [image[r - 1][c - 1],
                  image[r - 1][c],
                  image[r - 1][c + 1],
                  image[r][c - 1],
                  image[r][c],
                  image[r][c + 1],
                  image[r + 1][c - 1],
                  image[r + 1][c],
                  image[r + 1][c + 1]]
        index = b_to_i(digits)

        newchar = algo[index]
        newrow << newchar
      end
    }
    newimage << newrow
  }
  newimage
end

def draw(image)
  image.each { |row|
    puts row.join("")
  }
end

def count_pixels(image)
  image.flatten.sort.find_index "."
end

def enlarge(image, n, fillchar)
  newimage = []
  rows = image.size
  cols = image[0].size

  n.times {
    newimage << Array.new(cols + 2 * n, fillchar)
  }
  image.each { |row|
    n.times {
      row = row.unshift(fillchar).push(fillchar)
    }
    newimage << row
  }
  n.times {
    newimage << Array.new(cols + 2 * n, fillchar)
  }
  newimage
end

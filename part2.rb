require_relative "lib.rb"

# It took a long time to run my part 1 - ~5mins, so I just grepped these
# from the output.
scanner_locs =
  Matrix[[0], [0], [0]],
  Matrix[[161], [27], [1255]],
  Matrix[[1217], [-84], [164]],
  Matrix[[62], [1041], [158]],
  Matrix[[153], [28], [-1079]],
  Matrix[[-1073], [-116], [1282]],
  Matrix[[128], [-1223], [1233]],
  Matrix[[87], [-39], [2421]],
  Matrix[[1223], [-1198], [168]],
  Matrix[[-1151], [1207], [50]],
  Matrix[[136], [-1288], [-1131]],
  Matrix[[-2416], [-119], [1371]],
  Matrix[[78], [-1197], [2568]],
  Matrix[[1322], [-65], [2438]],
  Matrix[[14], [1099], [2429]],
  Matrix[[-2380], [1060], [1261]],
  Matrix[[1291], [-1361], [2440]],
  Matrix[[1307], [1070], [2457]],
  Matrix[[2392], [-97], [2533]],
  Matrix[[14], [1069], [3784]],
  Matrix[[112], [2253], [2491]],
  Matrix[[1340], [1153], [3781]],
  Matrix[[1172], [1188], [1244]],
  Matrix[[2372], [1078], [2397]],
  Matrix[[-1168], [1164], [3614]],
  Matrix[[37], [1183], [4924]],
  Matrix[[1217], [1202], [4928]],
  Matrix[[-2241], [1171], [3739]],
  Matrix[[-1051], [-79], [3767]],
  Matrix[[-2], [2239], [4871]],
  Matrix[[1331], [2263], [4980]],
  Matrix[[-1124], [-1277], [3616]],
  Matrix[[2499], [2399], [4977]],
  Matrix[[1240], [2335], [6023]],
  Matrix[[1304], [3455], [4933]],
  Matrix[[-2389], [-1338], [3708]],
  Matrix[[-1043], [-2369], [3730]],
  Matrix[[2421], [2343], [3660]]

max = 0
scanner_locs.each_with_index { |s, i|
  (i + 1..scanner_locs.size - 1).each { |j|
    s2 = scanner_locs[j]
    m = manhattan_distance(s, s2)
    max = m > max ? m : max
    puts "Manhattan distance #{i}-#{j}: #{m}"
  }
}
puts "Max: #{max}"

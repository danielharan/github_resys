unless ARGV[0]
  puts "usage: ruby #{__FILE__} <test_file_name>" 
  exit -1
end

removed_values = IO.read("removed_values.txt").split("\n").inject({}) do |hash,line| 
  key, value = line.split(":")
  hash[key] = value
  hash
end

score = 0.0

test = IO.read(ARGV.first).split("\n").each do |line|
  key, values = line.split(":")
  score += 1 if values.split(",").include?(removed_values[key])
end

puts "score: #{score} (#{score / removed_values.keys.length} %)"

require 'rubygems'
require 'json'

unless ARGV[0]
  puts "usage: ruby #{__FILE__} <test_file_name>"
  puts "Assumes we have 20 predictions per user"
  exit -1
end

# Counter-intuitive result: the more data you have for a user, the worse the prediction

def two_decimals(num)
  (num * 100).round / 100.0
end

watches = JSON.parse(IO.read("../user_watches.txt"))

ranges  = [0..4, 5..9, 10..14, 15..24, 25..49, 50..74, 75..99, 100..249, 250..499, 500..749, 750..999, 1_000..10_000]

results = ranges.inject({}) {|hash,range| hash[range] = {:correct_in_top_10 => 0, :correct_in_top_20 => 0, :total => 0}; hash }

removed_values = IO.read("removed_values.txt").split("\n").inject({}) do |hash,line| 
  key, value = line.split(":")
  hash[key] = value
  hash
end

test = IO.read(ARGV.first).split("\n").each do |line|
  
  user_id, values = line.split(":")
  values          = values.split(",")
  
  user_watches    = watches[user_id].length
  range           = ranges.detect {|r| r.include?(user_watches)} 
  
  missing_value   = removed_values[user_id]
  
  if values[0,10].include?(missing_value)
    results[range][:correct_in_top_10] += 1
  elsif values[10,20].include?(missing_value)
    results[range][:correct_in_top_20] += 1
  end
  results[range][:total] += 1
end

puts ["# watched", "total", "top 10", "(%)", "top 20", "(%)"].join("\t")
results.keys.sort {|f1,f2| f1.first.to_i <=> f2.first.to_i}.each do |key|
  range_results = results[key]
  
  next if range_results[:total] == 0
  top10 = two_decimals(range_results[:correct_in_top_10].to_f / range_results[:total])
  top20 = two_decimals(range_results[:correct_in_top_20].to_f / range_results[:total])
  puts [key.to_s.ljust(8), range_results[:total], range_results[:correct_in_top_10], top10, range_results[:correct_in_top_20], top20].join("\t")
end

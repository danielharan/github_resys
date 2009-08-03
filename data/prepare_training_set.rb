require 'rubygems'
require 'json'

class Array
  def rand
    self[Kernel.rand(length)]
  end
end

watches = JSON.parse(IO.read("../user_watches.txt"))

to_remove = 4788 # use the same # as the test.txt set
removed = {}

while (to_remove > 0) do
  key = (watches.keys - removed.keys).rand
  next if watches[key].length == 1
  removed[key] = watches[key].rand
  watches[key] = watches[key] - [removed[key]]
  to_remove -= 1
  print '.' if (to_remove % 100) == 0
end
puts ''

def write_file(name, hash)
  puts "writing to #{name}"
  File.open(name, "w+") do |f|
    hash.each do |key,value|
      value = value.join(",") if value.is_a?(Array)
      f.puts "#{key}:#{value}"
    end
  end
end

write_file("removed_values.txt", removed)
write_file("training_data.txt", watches)

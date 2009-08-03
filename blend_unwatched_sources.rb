# This only works well if the provided results file to blend has *more than 10 suggestions per line*
# ruby blend_unwatched_sources.rb > results.txt
external = IO.readlines('20_suggestions_per_user.txt')

forked = IO.readlines('all_unwatched_sources.txt')

external.each_with_index do |line, index|
  key, values = line.split(":")
  external_values   = values.split(",")
  
  forked_values = forked[index].split(":").last.chomp
  forked_values = forked_values.nil? ? [] : forked_values.split(",")
  
  if forked_values.length <= 10
    external_values = (forked_values + (external_values - forked_values))[0,10].join(",")
    puts "#{key}:#{values}"
  else
    # At the top of the list, show the forks that also appear in the external list (even if they're in the 11..20)
    values = ((forked_values & external_values) + (forked_values - external_values))[0,10].join(',')
    puts "#{key}:#{values}"
  end
end
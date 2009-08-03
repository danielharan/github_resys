require 'lib/user'
require 'rubygems'
require 'json'

users = Hash.new {|h,k| h[k] = User.new}

IO.read("../data/data.txt").split("\n").each do |line|
  user_id, repo_id = line.split(":")
  users[user_id.to_i].watches << repo_id.to_i
end

users.keys.each do |user_id|
  users[user_id] = users[user_id].watches
end
puts JSON.generate(users)
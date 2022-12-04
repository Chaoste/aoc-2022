#!/usr/bin/ruby
require "set"

def to_priority(char)
  base_ord = char.ord < 'a'.ord ? 'A'.ord - 27 : 'a'.ord - 1
  priority = char.ord - base_ord
  return priority
end

input_name = 'input.txt'
sum = 0
group = []

File.foreach(input_name).with_index do |input_line, index|
  line = input_line.strip
  group.push(line.chars)
  if index % 3 == 2
    intersection = Set.new(group[0]) & Set.new(group[1]) & Set.new(group[2])
    sum += to_priority(intersection.to_a[0])
    group = []
  end
end

puts 'Sum of priorities:', sum
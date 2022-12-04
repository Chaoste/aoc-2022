#!/usr/bin/ruby
require "set"

input_name = 'input.txt'
sum = 0

File.foreach(input_name) do |input_line|
  line = input_line.strip
  first_compartment = line[0..line.length/2-1]
  second_compartment = line[line.length/2..]
  intersection = Set.new(first_compartment.chars) & Set.new(second_compartment.chars)
  if (intersection.to_a.length != 1) or (first_compartment.length != second_compartment.length)
    puts 'ERROR', line, first_compartment, second_compartment, intersection
    exit
  end
  char_ord = intersection.to_a[0].ord
  base_ord = char_ord < 'a'.ord ? 'A'.ord - 27 : 'a'.ord - 1
  priority = char_ord - base_ord
  sum += priority
end

puts 'Sum of priorities:', sum
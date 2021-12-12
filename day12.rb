# frozen_string_literal: true

require 'pry'

file_data = File.read('day12input.txt').split("\n")
caves = {}
cave_connections = Hash.new([])
split_cave_connection = []

file_data.map do |cave_connection|
  split_cave_connection << cave_connection.split('-')
end

split_cave_connection.each do |connection|
  cave_connections[connection[0]] += [connection[1]]
  cave_connections[connection[1]] += [connection[0]]
end

class PassagePathing
  def initialize(caves:)
    @caves = caves
  end

  def part1
    path_count = find_paths
  end

  def part2
    path_count = find_paths
  end

  def find_paths
    is_part1 = self.caller.first.include?('part1')
    @paths = []
    partial_paths = ["start"].product(@caves["start"].connections).map { |path| path }

    while !partial_paths.empty? do
      new_partial_paths = []

      partial_paths.each do |partial_path|
        valid_caves = is_part1 ? next_valid_caves(partial_path) : next_valid_caves_part2(partial_path)

        if valid_caves.empty?
          if completed_path?(partial_path)
            @paths << partial_path
          end

          next
        end

        valid_caves.each { |cave| new_partial_paths << partial_path + [cave] }
      end

      partial_paths = new_partial_paths
    end

    @paths.length
  end

  def completed_path?(path)
    path.last == "end"
  end

  def visited_small_cave_twice?(partial_path, connection)
    partial_path.any? { |cave| !@caves[cave].large_cave && partial_path.count(cave) > 1 && partial_path.include?(connection) } && !@caves[connection].large_cave
  end

  def next_valid_caves(partial_path)
    connections = @caves[partial_path.last].connections
    valid_caves = []

    connections.each do |connection|
      valid_caves << connection unless connection == "start" || (!@caves[connection].large_cave && partial_path.include?(connection)) || completed_path?(partial_path)
    end

    valid_caves
  end

  def next_valid_caves_part2(partial_path)
    connections = @caves[partial_path.last].connections

    valid_caves = []
    connections.each do |connection|
      valid_caves << connection unless connection == "start" || visited_small_cave_twice?(partial_path, connection) || completed_path?(partial_path)
    end

    valid_caves
  end
end

class Cave
  def initialize(connections:, name:)
    @connections = connections
    @name = name
    @large_cave = name == name.upcase ? true : false
  end

  attr_accessor :connections, :name, :large_cave
end

cave_connections.each do |cave, connections|
  caves[cave] = Cave.new(connections: connections, name: cave)
end

passage_pathing = PassagePathing.new(caves: caves)

puts "Part 1: #{ passage_pathing.part1 }"
puts "Part 2: #{ passage_pathing.part2 }"

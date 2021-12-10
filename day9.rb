# frozen_string_literal: true

require 'pry'

file_data = {}

File.read('day9input.txt').split("\n").each_with_index.map do |line, index|
   file_data[index] = line.split('').map(&:to_i)
end

class SmokeBasin
  def initialize(input:)
    @height_map = input
    @basins = []
  end

  def part1
    low_points = find_low_points
    calculate_risk_level_sum(low_points)
  end

  def part2
    low_points = find_low_points

    low_points.each do |low_point|
      @basin_points = {}
      neighbours = find_neighbours(low_point[0][0], low_point[0][1])
      @basins << find_basin(low_point, neighbours)
    end

    return @basins.map(&:length).max(3).inject(:*)
  end

  def find_low_points
    low_points = {}

    @height_map.each do |row_index, line|
      line.each_with_index do |height, column_index|
        neighbours = find_neighbours(row_index, column_index)
        low_points[[row_index, column_index]] = height if low_point?(height, neighbours)
      end
    end

    low_points
  end

  def find_basin(low_point, neighbours)
    basin_points = []
    neighbours.select do |(row_index, column_index), height|

      next if height == 9 || @basin_points.values.any? { |value| value.include?([[row_index, column_index], height]) }
      basin_points << [[row_index, column_index], height] if height > low_point[1]
    end

    return if basin_points.empty?
    @basin_points[low_point] = basin_points

    basin_points.each do |low_point|
      neighbours = find_neighbours(low_point[0][0], low_point[0][1])
      neighbours.reject! { |neighbour, height| @basin_points.include?([neighbour, height]) }
      find_basin(low_point, neighbours)
    end

    return @basin_points.map { |_, heights| heights.map { |height| height[1] } }.flatten << low_point[1]
  end

  def find_neighbours(row_index, column_index)
    neighbours = {}
    neighbours[[row_index, column_index + 1]] = @height_map[row_index][column_index + 1] unless column_index == @height_map[row_index].length - 1
    neighbours[[row_index, column_index - 1]] = @height_map[row_index][column_index - 1] unless column_index == 0
    neighbours[[row_index + 1, column_index]] = @height_map[row_index + 1][column_index] unless row_index == @height_map.length - 1
    neighbours[[row_index - 1, column_index]] = @height_map[row_index - 1][column_index] unless row_index == 0
    neighbours
  end

  def low_point?(height, neighbours)
    neighbours.values.all? { |neighbour| neighbour > height }
  end

  def calculate_risk_level_sum(low_points)
    low_points.values.map { |low| low += 1}.sum
  end
end

smoke_basin = SmokeBasin.new(input: file_data)
puts "Part 1: #{smoke_basin.part1}"
puts "Part 2: #{smoke_basin.part2}"

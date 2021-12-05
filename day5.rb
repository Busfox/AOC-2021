# frozen_string_literal: true

require 'pry'

file_data = File.read('day5input.txt').split("\n").map { |line| line.split(' -> ').map { |coordinate| coordinate.split(',').map(&:to_i) } }

class HydrothermalVents
  def initialize(coordinates:)
    @vent_start_end_coordinates = coordinates
    @all_vent_coordinates = Hash.new(0)
    @horizontal_vertical_vent_coordinates = Hash.new(0)
  end

  def horizontal?(coords)
    coords[0][1] == coords[1][1]
  end

  def vertical?(coords)
    coords[0][0] == coords[1][0]
  end

  def find_vents
    @vent_start_end_coordinates.each do |coordinates|
      if vertical?(coordinates) || horizontal?(coordinates)
        extend_line(coordinates)
      else
        extend_line_diagonally(coordinates)
      end
    end

    return find_intersection_points
  end

  def extend_line(coordinates)
    all_x_coords = find_numbers_between(coordinates[0][0], coordinates[1][0])
    all_y_coords = find_numbers_between(coordinates[0][1], coordinates[1][1])
    line = all_x_coords.product(all_y_coords)

    line.each do |point|
      @all_vent_coordinates[point] += 1
      @horizontal_vertical_vent_coordinates[point] += 1
    end
  end

  def extend_line_diagonally(coordinates)
    all_x_coords = find_numbers_between(coordinates[0][0], coordinates[1][0])
    all_y_coords = find_numbers_between(coordinates[0][1], coordinates[1][1])
    diagonal_line = all_x_coords.zip(all_y_coords)

    diagonal_line.each do |point|
      @all_vent_coordinates[point] += 1
    end
  end

  def find_numbers_between(num1, num2)
    (
      num1 > num2 ? num1.downto(num2) : num1.upto(num2)
    ).to_a
  end

  def find_intersection_points
    return [
      @horizontal_vertical_vent_coordinates.count { |k,v| v > 1 },
      @all_vent_coordinates.count { |k,v| v > 1 }
    ]
  end
end

hydrothermal_vents = HydrothermalVents.new(coordinates: file_data).find_vents
puts "Part1: #{ hydrothermal_vents[0].to_s }"
puts "Part2: #{ hydrothermal_vents[1].to_s }"

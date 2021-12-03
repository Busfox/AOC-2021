# frozen_string_literal: true

require 'pry'

file_data = File.read('day1input.txt').split("\n").map(&:to_i)

# SonarSweep
class SonarSweep
  def initialize(input:)
    @depth_measurements = input
  end

  def part1
    count = 0
    @depth_measurements.each_cons(2) do |depth|
      count += 1 if depth[1] > depth[0]
    end

    count
  end

  def part2
    depth_measurement_groups = @depth_measurements.each_cons(3).map { |group| group }

    count = 0
    depth_measurement_groups.each_cons(2) do |depth|
      count += 1 if depth[1].sum > depth[0].sum
    end

    count
  end
end

sonar_sweep = SonarSweep.new(input: file_data)
puts sonar_sweep.part1
puts sonar_sweep.part2

# frozen_string_literal: true

require 'pry'

file_data = File.read('day2input.txt')
                .split("\n")
                .map { |direction| direction.split(' ') }
                .map { |part| [part[0], part[1].to_i] }

# SonarSweep
class Drive
  def initialize(input:)
    @planned_course = input
  end

  def part1
    horizontal_position = 0
    depth = 0

    @planned_course.each do |step|
      case step[0]
      when "forward"
        horizontal_position += step[1]
      when "down"
        depth += step[1]
      when "up"
        depth -= step[1]
      end
    end
    [horizontal_position, depth]
  end

  def part2
    horizontal_position = 0
    depth = 0
    aim = 0

    @planned_course.each do |step|
      case step[0]
      when "forward"
        horizontal_position += step[1]
        depth += aim * step[1]
      when "down"
        aim += step[1]
      when "up"
        aim -= step[1]
      end
    end
    [horizontal_position, depth, aim]
  end
end

drive = Drive.new(input: file_data)

result1 = drive.part1
puts result1[0] * result1[1]

result2 = drive.part2
puts result2[0] * result2[1]

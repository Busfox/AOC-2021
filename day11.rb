# frozen_string_literal: true

require 'pry'

file_data = {}
File.read('day11input.txt').split("\n").each_with_index do |line, row_index|
  line.chars.each_with_index do |char, column_index|
    file_data[[row_index, column_index]] = char.to_i
  end
end

class DumboOctopus
  def initialize(input:)
    @octopus_energies = input
    @flashes = 0
    @step = 0
  end

  def step
    @step += 1
    @flashed_octopi = []
    @octopus_energies.transform_values! { |energy| energy + 1}

    octopi_to_flash = flashing_octopi(@octopus_energies)
    octopi_to_flash.each do |octopus|
      flash(octopus[0])
    end

    @octopus_energies.transform_values! { |energy| energy > 9 ? 0 : energy }

    @flashes += @octopus_energies.values.count { |energy| energy == 0 }
  end

  def flashing_octopi(octopi)
    octopi.select { |position, energy| energy > 9 }
  end

  def flash(octopus_position)
    return if @flashed_octopi.include?(octopus_position)
    @flashed_octopi |= [octopus_position]
    neighbours = find_neighbours(octopus_position)
    @octopus_energies.each do |position, _energy|
      if neighbours.include?(position)
        @octopus_energies[position] += 1
        neighbours[position] += 1
      end
    end

    octopi_to_flash = flashing_octopi(neighbours)

    octopi_to_flash.each do |octopus|
      flash(octopus[0])
    end unless octopi_to_flash.empty?
  end

  def find_neighbours(octopus_position)
    neighbours = {}

    neighbours[[octopus_position[0] - 1, octopus_position[1] - 1]] = @octopus_energies[[octopus_position[0] - 1, octopus_position[1] - 1]]
    neighbours[[octopus_position[0] - 1, octopus_position[1]]] = @octopus_energies[[octopus_position[0] - 1, octopus_position[1]]]
    neighbours[[octopus_position[0] - 1, octopus_position[1] + 1]] = @octopus_energies[[octopus_position[0] - 1, octopus_position[1] + 1]]
    neighbours[[octopus_position[0], octopus_position[1] - 1]] = @octopus_energies[[octopus_position[0], octopus_position[1] - 1]]
    neighbours[[octopus_position[0], octopus_position[1] + 1]] = @octopus_energies[[octopus_position[0], octopus_position[1] + 1]]
    neighbours[[octopus_position[0] + 1, octopus_position[1] - 1]] = @octopus_energies[[octopus_position[0] + 1, octopus_position[1] - 1]]
    neighbours[[octopus_position[0] + 1, octopus_position[1]]] = @octopus_energies[[octopus_position[0] + 1, octopus_position[1]]]
    neighbours[[octopus_position[0] + 1, octopus_position[1] + 1]] = @octopus_energies[[octopus_position[0] + 1, octopus_position[1] + 1]]
    neighbours.compact
  end

  def part1(n)
    n.times { step }
    @flashes
  end

  def part2
    loop do
      step
      return @step if @octopus_energies.all? { |position, value| value == 0 }
    end
  end
end

dumbo_octopus = DumboOctopus.new(input: file_data)

puts "Part 1: #{dumbo_octopus.part1(50)}"
puts "Part 2: #{dumbo_octopus.part2}"
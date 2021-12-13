# frozen_string_literal: true

require 'pry'
require 'set'

coordinates = Set.new
folds = []

file_data = File.read('day13input.txt').split("\n\n")

file_data[0].split("\n").each do |coordinate|
  coordinates << coordinate.split(',').map(&:to_i)
end

file_data[1].split("\n").each do |fold|
  parsed_fold = fold.tr('fold along ','').split('=')
  folds << { parsed_fold[0] => parsed_fold[1].to_i }
end

class TransparentOrigami
  def initialize(coordinates:, folds:)
    @coordinates = coordinates
    @folds = folds
  end

  def part1
    if @folds.first.keys.first == "y"
      fold_along_y(@folds.first.values.first)
    else
      fold_along_x(@folds.first.values.first)
    end
    return @coordinates.count
  end

  def part2
    @folds.each do |fold|
      if fold.keys.first == "y"
        fold_along_y(fold.values.first)
      else
        fold_along_x(fold.values.first)
      end
    end

    return find_code

  end

  def fold_along_x(line)
    @coordinates.map! do |x, y|
      x > line ? [(line * 2) - x, y] : [x, y]
    end
  end

  def fold_along_y(line)
    @coordinates.map! do |x, y|
      y > line ? [x, (line * 2) - y] : [x, y]
    end
  end

  def find_code
    map = draw_initial_map

    @coordinates.each do |x, y|
      map[y][x] = "#"
    end

    map
  end

  def draw_initial_map
    map = []
    max_x = @coordinates.max[0]
    max_y = @coordinates.map { |_x, y| y }.max

    (max_y + 1).times do
      line = []
      (max_x + 1).times { line << ' ' }
      map << line
    end

    map
  end
end

transparent_origami = TransparentOrigami.new(coordinates: coordinates, folds: folds)
puts "Part 1: #{ transparent_origami.part1 }"
puts "Part 2:"
transparent_origami.part2.each do |line|
  puts line.join
end

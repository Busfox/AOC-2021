# frozen_string_literal: true

require 'pry'

file_data = File.read('day7input.txt').split(',').map(&:to_i)

class WhaleTreachery
  def initialize(input:)
    @input = input
  end

  def find_position_part_1
    range = (@input.min..@input.max).to_a
    best_fuel_consumption = {}
    range.each do |n|
      fuel_consumption = @input.map { |sub| (sub - n).abs }.sum
      best_fuel_consumption = {n => fuel_consumption} if best_fuel_consumption.empty? || fuel_consumption < best_fuel_consumption.values.first
    end

    return best_fuel_consumption
  end

  def find_position_part_2
    range = (@input.min..@input.max).to_a
    best_fuel_consumption = {}
    range.each do |n|
      fuel_consumption = @input.map do |sub|
        steps = (sub - n).abs
        fuel = (1..steps).to_a.sum
      end.sum
      best_fuel_consumption = {n => fuel_consumption} if best_fuel_consumption.empty? || fuel_consumption < best_fuel_consumption.values.first
    end

    return best_fuel_consumption
  end
end

whale_treachery = WhaleTreachery.new(input: file_data)
puts whale_treachery.find_position_part_1.to_s
puts whale_treachery.find_position_part_2.to_s

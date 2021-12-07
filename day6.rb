# frozen_string_literal: true

require 'pry'

class LanternfishReproductionMapper
  def initialize(breeding_schedule:)
    @breeding_schedule = breeding_schedule
  end

  def model_births(days)
    days.times do |day|
      new_births = 0
      updated_breeding_schedule = Hash.new(0)
      @breeding_schedule.map do |k, v|
        if k == 0
          new_births = v
          updated_breeding_schedule[6] += v
        else
          updated_breeding_schedule[k - 1] += v
        end
      end

      updated_breeding_schedule[8] = new_births unless new_births == 0
      @breeding_schedule = updated_breeding_schedule
    end

    return @breeding_schedule.values.sum
  end
end

file_data = File.read('day6input.txt').split(',').map(&:to_i)
breeding_schedule = {}
0..9.times { |n| breeding_schedule[n] = 0}
file_data.each { |e| breeding_schedule[e] += 1 }

reproduction_mapper = LanternfishReproductionMapper.new(breeding_schedule: breeding_schedule)
puts "Part 1: #{ reproduction_mapper.model_births(80) }"
puts "Part 2: #{ reproduction_mapper.model_births(256) }"
# frozen_string_literal: true

require 'pry'

file_data = File.read('day3input.txt').split("\n").map { |i| i.chars.map(&:to_i) }

class BinaryDiagnostic
  def initialize(input:)
    @binary_list = input
    @transposed_binary_list = input.transpose(&:reverse)
  end

  def calculate_power_consumption
    gamma = []
    epsilon = []

    @transposed_binary_list.each do |binaries|
      gamma << binaries.max_by{ |binary| binaries.count(binary) }
      epsilon << binaries.min_by{ |binary| binaries.count(binary) }
    end

    gamma_rate = gamma.join.to_i(2)
    epsilon_rate = epsilon.join.to_i(2)

    return gamma_rate * epsilon_rate
  end

  def find_oxygen_and_co2_ratings
    oxygen_rating = calculate_oxygen_rating(0, @binary_list).join.to_i(2)
    co2_rating = calculate_co2_rating(0, @binary_list).join.to_i(2)

    return oxygen_rating * co2_rating
  end

  def calculate_oxygen_rating(index, binaries_list)
    transposed_binaries = binaries_list.transpose(&:reverse)
    most_common_number = transposed_binaries[index].sort.reverse.max_by{ |binary| transposed_binaries[index].count(binary) }

    reduced_binaries = binaries_list.map do |binaries|
      binaries if binaries[index] == most_common_number
    end.compact

    return reduced_binaries.flatten if reduced_binaries.length == 1

    calculate_oxygen_rating(index += 1, reduced_binaries)
  end

  def calculate_co2_rating(index, binaries_list)
    transposed_binaries = binaries_list.transpose(&:reverse)
    least_common_number = transposed_binaries[index].sort.min_by{ |binary| transposed_binaries[index].count(binary) }

    reduced_binaries = binaries_list.map do |binaries|
      binaries if binaries[index] == least_common_number
    end.compact

    return reduced_binaries.flatten if reduced_binaries.length == 1

    calculate_co2_rating(index += 1, reduced_binaries)
  end
end

binary_diagnostic = BinaryDiagnostic.new(input: file_data)
puts binary_diagnostic.calculate_power_consumption
puts binary_diagnostic.find_oxygen_and_co2_ratings
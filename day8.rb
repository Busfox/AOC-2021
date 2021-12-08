# frozen_string_literal: true

require 'pry'

file_data = File.read('day8input.txt').split("\n")
signals = []
outputs = []
file_data.map do |i|
  raw_signals, raw_outputs = i.split(' | ')
  signals << raw_signals.split(' ').map { |signal| signal.chars.sort.join }
  outputs << raw_outputs.split(' ').map { |signal| signal.chars.sort.join }
end

class SevenSegmentSearch
  def initialize(signals:, outputs:)
    @signals = signals
    @outputs = outputs
  end

  def delete_first_if(signals, &block)
    signals.delete(signals.find(&block))
  end

  def count_simple_signals
    count = 0

    @outputs.each_with_index do |output,index|
      signal_map = create_signal_map(index)

      signal_map.each do |signal|
        next unless [1,4,7,8].include?(signal[0])
        count += output.count(signal[1])
      end
    end
    count
  end

  def add_output_values
    output_values = []
    @outputs.each_with_index do |output,index|
      signal_map = create_signal_map(index)
      output_values << output.map { |signal| signal_map.key(signal) }.join.to_i
    end

    return output_values.sum
  end

  def create_signal_map(index)
    signals = @signals[index].dup
    signal_map = {}

    signal_map[1] = delete_first_if(signals) { |signal| signal.length == 2 }
    signal_map[4] = delete_first_if(signals) { |signal| signal.length == 4 }
    signal_map[7] = delete_first_if(signals) { |signal| signal.length == 3 }
    signal_map[8] = delete_first_if(signals) { |signal| signal.length == 7 }
    signal_map[9] = delete_first_if(signals) { |signal| signal.length == 6 && signal_map[4].chars.all? { |char| signal.include?(char) } }
    signal_map[3] = delete_first_if(signals) { |signal| signal.length == 5 && signal_map[7].chars.all? { |char| signal.include?(char) } }
    signal_map[0] = delete_first_if(signals) { |signal| signal.length == 6 && signal_map[7].chars.all? { |char| signal.include?(char) } }
    signal_map[6] = delete_first_if(signals) { |signal| signal.length == 6 }
    signal_map[5] = delete_first_if(signals) { |signal| signal.length == 5 && signal.chars.all? { |char| signal_map[6].include?(char) } }
    signal_map[2] = delete_first_if(signals) { |signal| true }

    return signal_map
  end
end

seven_segment_search = SevenSegmentSearch.new(signals: signals, outputs: outputs)
puts "Part 1: #{seven_segment_search.count_simple_signals}"
puts "Part 2: #{seven_segment_search.add_output_values}"

# frozen_string_literal: true

require 'pry'

file_data = File.read('day4input.txt').split("\n\n")

numbers = file_data[0].split(',').map(&:to_i)

raw_boards = file_data.drop(1).map { |board| board.split("\n").map { |line| line.split(' ').map(&:to_i) } }

boards = Hash.new
raw_boards.each_with_index do |board, index|
  boards[index] = board.map do |i|
    i.to_h { |y| [y, false] }
  end
end

class GiantSquid
  def initialize(numbers:, boards:)
    @numbers = numbers
    @boards = boards
  end

  def call_numbers
    winner = nil
    @numbers.each do |number|
      @boards.each do |board_number, board|
        check_board_for_number(board_number, board, number)
      end

      winner = check_for_winner

      unless winner == false
        winner = [number, winner.uniq[0]]
        break
      end
    end
    return find_score(winner[0], @boards[winner[1]])
  end

  def call_numbers_part2
    winners = []
    @numbers.each do |number|
      @boards.each do |board_number, board|
        check_board_for_number(board_number, board, number)
      end

      winner = check_for_winner

      if winner
        winner.uniq.each do |board_number|
          winners << [number, board_number]
        end
      end
      break if winner.uniq.length == @boards.length
    end

    return find_score(winners.last[0], @boards[winners.transpose[1].uniq.last])
  end

  def check_board_for_number(board_number, board, target_number)
    board.each_with_index do |line, index|
      if line.keys.include?(target_number)
        @boards[board_number][index][target_number] = true
      end
    end
  end

  def check_for_winner
    winning_boards = []
    @boards.each do |board_number, board|
      marked_positions = []
      board.each_with_index do |line, index|
        line.each_with_index.map { |(_,v),index| index if v == true }.compact.each do |i|
          marked_positions << [index, i]
        end
      end

      marked_positions.transpose.each do |positions|
        positions.each do |index|
          winning_boards << board_number if positions.count(index) == 5
        end
      end
    end

    return winning_boards.empty? ? false : winning_boards
  end

  def find_score(final_number, winning_board)
    unmarked_numbers_sum = 0
    winning_board.each do |line|
      unmarked_numbers_sum += line.select { |k,v| v == false }.to_a.map { |e| e[0] }.sum
    end
    return unmarked_numbers_sum * final_number
  end
end

giant_squid = GiantSquid.new(numbers: numbers, boards: boards)
puts giant_squid.call_numbers
puts giant_squid.call_numbers_part2

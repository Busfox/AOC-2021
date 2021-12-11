# frozen_string_literal: true

require 'pry'

file_data = File.read('day10input.txt').split("\n")

class SyntaxScoring

  SYNTAX_SCORES = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
  }

  AUTOCOMPLETION_SCORES = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
  }

  DELIMITERS = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
  }

  def initialize(input:)
    @input = input
  end

  def calculate_syntax_error_score(line)
    delimiters_to_close = []
    score = 0

    line.chars.each do |char|
      if DELIMITERS.values.include?(char)
        open_char = DELIMITERS.key(char)
        if delimiters_to_close.last == open_char
          delimiters_to_close.pop
        else
          return SYNTAX_SCORES[char]
        end
      else
        delimiters_to_close << char
      end
    end
    @incomplete_lines << line
    return 0
  end

  def calculate_autocompletion_score(line)
    delimiters_to_close = []

    line.chars.each do |char|
      if DELIMITERS.values.include?(char)
        open_char = DELIMITERS.key(char)
        delimiters_to_close.pop if delimiters_to_close.last == open_char
      else
        delimiters_to_close << char
      end
    end

    autocompletion_score = 0

    delimiters_to_close.reverse.each do |delimiter|
      autocompletion_score = autocompletion_score * 5
      closing_delimiter = DELIMITERS[delimiter]

      autocompletion_score += AUTOCOMPLETION_SCORES[closing_delimiter]
    end

    return autocompletion_score
  end

  def part1
    syntax_error_score = 0
    @incomplete_lines = []

    @input.each do |line|
      syntax_error_score += calculate_syntax_error_score(line)
    end

    syntax_error_score
  end

  def part2
    autocompletion_score = []

    @incomplete_lines.each do |line|
      autocompletion_score << calculate_autocompletion_score(line)
    end

    autocompletion_score.sort!
    autocompletion_score[autocompletion_score.length/2]
  end
end

syntax_scoring = SyntaxScoring.new(input: file_data)
puts "Part 1: #{syntax_scoring.part1}"
puts "Part 2: #{syntax_scoring.part2}"

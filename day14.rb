# frozen_string_literal: true

require 'pry'

polymer_template, temp_rules = File.read('day14input.txt').split("\n\n")
polymer_pair_counts = Hash.new{ 0 }
[' ', polymer_template.split('')].flatten(1).each_cons(2) do |pair|
  polymer_pair_counts[pair.join] += 1
end

rules = {}
temp_rules.split("\n").map do |rule|
  rule = rule.split(' -> ')
  rules[rule[0]] = rule[1]
end

class Polymerization
  def initialize(polymer_pair_counts:, rules:)
    @polymer_pair_counts = polymer_pair_counts
    @rules = rules
  end

  def result(n)
    n.times do
      apply
    end

    counts = find_char_counts
    counts.values.max - counts.values.min
  end

  def apply
    pair_counts = @polymer_pair_counts.dup

    pair_counts.each do |pair, quantity|
      element_to_insert = @rules[pair] || next

      [pair[0], element_to_insert, pair[1]].each_cons(2) do |new_pair|
        @polymer_pair_counts[new_pair.join] += quantity
      end

      @polymer_pair_counts[pair] -= quantity

      @polymer_pair_counts.delete(pair) if @polymer_pair_counts[pair] == 0
    end
  end

  def find_char_counts
    counts = Hash.new { 0 }
    @polymer_pair_counts.each do |pair, quantity|
      counts[pair[1]] += quantity
    end
    counts
  end
end

polymerization = Polymerization.new(polymer_pair_counts: polymer_pair_counts, rules: rules)
puts polymerization.result(40).to_s

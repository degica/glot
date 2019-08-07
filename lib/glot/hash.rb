# frozen_string_literal: true

# Mixin for hash
class Hash
  def deep_traverse
    stack = map { |k, v| [[k], v] }
    until stack.empty?
      key, value = stack.pop
      yield(key, value)
      value.each { |k, v| stack.push [key.dup << k, v] } if value.is_a? Hash
    end
  end

  def deep_key_sort!
    orig = dup
    clear

    orig.map { |k, v| process(k, v) }.sort.each do |k, v|
      self[k] = v
    end
  end

  attr_accessor :reference_names

  private

  def process(key, value)
    value.deep_key_sort! if value.is_a? Hash
    [key, value]
  end
end

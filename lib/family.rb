# coding: us-ascii
# frozen_string_literal: true

# Copyright (C) 2012 Kenichi Kamiya

# Family is a Container class.
# For provide "Homogeneous Array" in Ruby.
# But the condition is not bound by "types" ... :)

require 'forwardable'
require 'eqq'
require_relative 'family/version'
require_relative 'family/singleton_class'

# @example Simplify
#   list = Family.new Integer
#   list << 7    #=> 7
#   list << 1.0  #=> Exception
#   list << 1    #=> 1
#   list.inspect #=> "Integer ===: [7, 1]"
# @example Not bound by "Type"
#   list = Family.new /\A\S+\z/
#   list << 'a b c' #=> Exception
#   list << 'abc'   #=> "abc"
#   list.inspect    #=> "/\A\S+\z/ ===: ["abc"]"
# @example HighLayer definition
#   list = Family.define { AND(Float, 3..6) }
#   list << 4       #=> Exception
#   list << 2.0     #=> Exception
#   list << 4.0     #=> 4.0
#   list.inspect    #=> a Proc ===: [4.0]
# @note return self -> Array
#   * #flatten is different
#   * #flatten! is none
#   * #product
# @note removed from Array
#   * #flatten! is none
class Family
  extend Forwardable
  include Enumerable

  class MismatchedObject < TypeError; end

  class DSL
    include Eqq::Buildable
  end

  attr_reader :pattern

  def initialize(pattern, values: [])
    @pattern, @values = pattern, values.to_ary

    raise MismatchedObject unless valid?
  end

  def_delegators :@values, :join, :<=>, :==, :[], :at, :assoc,
                 :rassoc, :delete, :delete_at, :empty?, :fetch, :first, :last, :take, :tail,
                 :flatten, :include?, :index, :to_s, :length, :size, :pack,
                 :pop, :product, :reverse_each, :rindex, :sample,
                 :slice, :slice!, :transpose, :zip, :to_h, :bsearch

  def_enums :@values, :each, :each_index, :cycle, :combination,
            :repeated_combination, :permutation, :repeated_permutation

  def_set_operator :&
  def_set_operator :+
  def_set_operator :-
  def_set_operator :|

  # @return [Array]
  def values
    @values.dup
  end

  alias_method :to_ary, :values
  alias_method :to_a, :values

  # @return [String]
  def inspect
    "Family<#{@pattern.inspect}>: #{@values.inspect}"
  end

  # @return [self]
  def <<(value)
    raise MismatchedObject unless family?(value)

    @values << value
    self
  end

  alias_method :push, :<<

  # @return [self]
  def unshift(value)
    raise MismatchedObject unless family?(value)

    @values.unshift(value)
    self
  end

  # @param [#all?] list
  # @return [self]
  def concat(list)
    raise MismatchedObject unless similar?(list)

    @values.concat(list)
    self
  end

  def family?(value)
    @pattern === value
  end

  # @param [#all?] list
  def similar?(list)
    list.all? { |v| family?(v) }
  end

  def valid?
    similar?(@values)
  end

  # @return [Family]
  def map(&block)
    return to_enum(__callee__) { size } unless block

    self.class.__new__(@pattern, @values.map(&block))
  end

  alias_method :collect, :map

  # @return [self]
  def map!(&block)
    return to_enum(__callee__) { size } unless block

    mapped = @values.map(&block)
    raise InvalidOperation unless similar?(mapped)

    @values = mapped
    self
  end

  alias_method :collect!, :map!

  # @return [Family]
  def *(times_or_delimiter)
    case times_or_delimiter
    when Integer
      self.class.__new__(@pattern, @values * times_or_delimiter)
    when String
      join(times_or_delimiter)
    else
      raise ArgumentError
    end
  end

  # @return [self]
  def to_family
    self
  end

  # @return [self]
  def freeze
    @values.freeze
    super
  end

  # @param [Symbol] name
  def method_missing(name, *args, &block)
    return super unless @values.respond_to?(name)

    warn("WARN:#{__FILE__}:#{__LINE__}:unexpected method, not checked any patterns")
    @values.__send__(name, *args, &block)
  end

  # @return [self]
  def clear
    @values.clear
    self
  end

  # @return [Family]
  def compact
    self.class.__new__(@pattern, @values.compact)
  end

  # @return [self, nil]
  def compact!
    @values.compact! && self
  end

  # @return [Number]
  def hash
    _comparison_values.hash
  end

  def eql?(other)
    other.kind_of?(::Family) &&
      (_comparison_values == other._comparison_values)
  end

  # @return [self, nil]
  def reject!(&block)
    return to_enum(__callee__) unless block

    @values.reject!(&block) && self
  end

  # @return [self]
  def delete_if(&block)
    return to_enum(__callee__) unless block

    reject!(&block)
    self
  end

  # @return [self, nil]
  def select!(&block)
    return to_enum(__callee__) unless block

    @values.select!(&block) && self
  end
  alias_method :filter!, :select!

  def keep_if(&block)
    return to_enum(__callee__) unless block

    select!(&block)
    self
  end

  # @return [self]
  def fill(*args, &block)
    filled = @values.dup.fill(*args, &block)
    raise MismatchedObject unless similar?(filled)

    @values = filled
    self
  end

  # @param [#all?] list
  # @return [self]
  def replace(list)
    raise MismatchedObject unless similar?(list)

    @values = list.dup
    self
  end

  # @return [Family]
  def reverse
    self.class.__new__(@pattern, @values.reverse)
  end

  # @return [self]
  def reverse!
    @values.reverse!
    self
  end

  # @param [Integer] pos
  # @return [Family]
  def rotate(pos=1)
    self.class.__new__(@pattern, @values.rotate(pos))
  end

  # @param [Integer] pos
  # @return [self]
  def rotate!(pos=1)
    @values.rotate!(pos)
    self
  end

  # @return [Family]
  def shuffle(...)
    self.class.__new__(@pattern, @values.shuffle(...))
  end

  # @return [self]
  def shuffle!(...)
    @values.shuffle!(...)
    self
  end

  # @return [Family]
  def sort(&block)
    self.class.__new__(@pattern, @values.sort(&block))
  end

  # @return [self, nil]
  def sort!(&block)
    @values.sort!(&block) && self
  end

  # @return [Family]
  def sort_by(&block)
    self.class.__new__(@pattern, @values.sort_by(&block))
  end

  # @return [self, nil]
  def sort_by!(&block)
    @values.sort_by!(&block) && self
  end

  # @return [Family]
  def uniq(&block)
    self.class.__new__(@pattern, @values.uniq(&block))
  end

  # @return [self, nil]
  def uniq!(&block)
    @values.uniq!(&block) && self
  end

  # @param [Integer, Range<Integer>] selectors
  # @return [Family]
  def values_at(*selectors)
    self.class.__new__(@pattern, @values.values_at(*selectors))
  end

  protected

  def _values
    @values
  end

  def _comparison_values
    [@pattern, @values]
  end

  private

  def initialize_copy(original)
    @values = @values.dup
  end
end

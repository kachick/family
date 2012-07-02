# Copyright (C) 2012 Kenichi Kamiya

# Family is a Container class
# For provide "Homogeneous Array" in Ruby
# And it doesn't depend just the "Type" :)

require 'forwardable'
require 'validation'

# @example Old Style
# list = Family.new Integer
# list << 7 #=> 7
# list << 1.0 #=> Exception
# list << 1 #=> 1
# list.inspect #=> Integer[7, 1]
# @example Not only "Type"
# list = Family.new /\A\S+\z/
# list << 'a b c' #=> Exception
# list << 'abc' #=> 'abc'
# list.inspect #=> /\A\S+\z/['abc']
# @example HighLayer definition
# list = Family.new{AND(Symbol, /\A\S+\z/)}
# @note return self -> Array
#   * #flatten is different
#   * #flatten! is none
#   * #product
# @note removed from Array
#   * #flatten! is none
class Family

  extend Forwardable
  include Enumerable
  include Validation

  VERSION = '0.0.1.1'

  class InvalidValue < TypeError; end
  class MismatchedObject < TypeError; end
  
  class DSL
    include Validation
    include Validation::Condition
  end
  
  class << self
    
    def define(values=[], &block)
      new DSL.new.instance_exec(&block), :===, values
    end
    
    private
    
    def def_enum(reciever, name)
    
      define_method name do |*args, &block|
        eval("#{reciever}").__send__ name, *args, &block
        self
      end

    end
    
    def def_enums(reciever, *names)
      names.each {|name|def_enum reciever, name}
    end
    
    def def_set_operator(operator)

      define_method operator do |other|
        other = other.kind_of?(::Family) ? other._values : other.to_ary
        raise MismatchedObject unless similar? other
        
        self.class.new @proof, @comparison, @values.__send__(operator, other)
      end
  
    end
    
  end
  
  attr_reader :proof, :comparison
  
  def initialize(proof, comparison=:===, values=[])
    @proof, @comparison, @values = proof, comparison, values.to_ary

    raise MismatchedObject unless valid?
  end
  
  def_delegators :@values, :join, :<=>, :==, :[], :at, :assoc,
    :rassoc, :delete, :delete_at, :empty?, :fetch, :first, :last, :take, :tail,
    :flatten, :include?, :index, :to_s, :length, :size, :pack,
    :pop, :product, :reverse_each, :rindex, :sample,
    :slice, :slice!, :transpose, :zip

  def_enums :@values, :each, :each_index, :cycle, :combination,
    :repeated_combination, :permutation, :repeated_permutation
  
  def_set_operator :&
  def_set_operator :+
  def_set_operator :- # todo
  def_set_operator :|

  # @return [Array]
  def values
    @values.dup
  end
  
  alias_method :to_ary, :values
  alias_method :to_a, :values
  
  # @return [String]
  def inspect
    "<#{@proof.inspect}>#{@values.inspect}"
  end
  
  # @return [self]
  def <<(value)
    raise MismatchedObject unless family? value

    @values << value
    self
  end

  alias_method :push, :<<
  
  # @return [self]
  def unshift(value)
    raise MismatchedObject unless family? value

    @values.unshift value
    self
  end
  
  # @return [self]
  def concat(list)
    raise MismatchedObject unless similar? list

    @values.concat other
    self
  end
  
  def family?(value)
    @proof.__send__ @comparison, value
  end

  def similar?(list)
    list.all?{|v|family? v}
  end

  def valid?
    similar? @values
  end
  
  # @return [Family]
  def map(&block)
    self.class.new @proof, @comparison, @values.map(&block)
  end
  
  alias_method :collect, :map
  
  # @return [self]
  def map!(&block)
    return to_enum(__callee__) unless block_given?
    
    mapped = @values.map(&block)
    raise InvalidOperation unless similar? mapped
    
    @values = mapped
    self
  end
  
  alias_method :collect!, :map!
  
  # @return [Family]
  def *(times_or_delimiter)
    case times_or_delimiter
    when Integer
      self.class.new @proof, @comparison, @values * times_or_delimiter
    when String
      join times_or_delimiter
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
  
  def method_missing(name, *args, &block)
    return super unless @values.respond_to? name
    
    warn "WARN:#{__FILE__}:#{__LINE__}:unexpected method, not cheked any proofs"
    @values.__send__ name, *args, &block
  end

  # @return [self]
  def clear
    @values.clear
    self
  end
  
  # @return [self]
  def compact
    @values.compact
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
    return to_enum(__callee__) unless block_given?
    
    @values.reject!(&block) && self
  end
  
  # @return [self]
  def delete_if(&block)
    return to_enum(__callee__) unless block_given?
    
    reject!(&block)
    self
  end
  
  # @return [self, nil]
  def select!(&block)
    return to_enum(__callee__) unless block_given?
    
    @values.select!(&block) && self
  end
  
  def keep_if(&block)
    return to_enum(__callee__) unless block_given?
    
    select!(&block)
    self
  end
  
  # @return [self]
  def fill(*args, &block)
    filled = @values.dup.fill(*args, &block)
    raise MismatchedObject unless similar? filled
    
    @values = filled
    self
  end
  
  # @return [self]
  def replace(list)
    raise MismatchedObject unless similar? list
    
    @values = list.dup
    self
  end
  
  # @return [Family]
  def reverse
    self.class.new @proof, @comparison, @values.reverse
  end
  
  # @return [self]
  def reverse!
    @values.reverse!
    self
  end
  
  # @return [Family]
  def rotate(pos=1)
    self.class.new @proof, @comparison, @values.rotate(pos)
  end
  
  # @return [self]
  def rotate!(pos=1)
    @values.rotate! pos
    self
  end
  
  # @return [Family]
  def shuffle(options={})
    self.class.new @proof, @comparison, @values.shuffle(options)
  end
  
  # @return [self]
  def shuffle!(options={})
    @values.shuffle! options
    self
  end
  
  # @return [Family]
  def sort(&block)
    self.class.new @proof, @comparison, @values.sort(&block)
  end
  
  # @return [self, nil]
  def sort!(&block)
    @values.sort!(&block) && self
  end

  # @return [Family]
  def sort_by(&block)
    self.class.new @proof, @comparison, @values.sort_by(&block)
  end
  
  # @return [self, nil]
  def sort_by!(&block)
    @values.sort_by!(&block) && self
  end
  
  # @return [Family]
  def uniq(&block)
    self.class.new @proof, @comparison, @values.uniq(&block)
  end
  
  # @return [self, nil]
  def uniq!(&block)
    @values.uniq!(&block) && self
  end
  
  # @return [Family]
  def values_at(*selectors)
    self.class.new @proof, @comparison, @values.values_at(*selectors)
  end
  
  protected
  
  def _values
    @values
  end
  
  def _comparison_values
    [@proof, @comparison, @values]
  end
  
  private
  
  def initialize_copy(original)
    @values = @values.dup
  end
  
end

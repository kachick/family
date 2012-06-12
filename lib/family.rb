$VERBOSE = true

require 'forwardable'
require 'validation'

# Family is a Container class
# For provide "Homogeneous Array" in Ruby
# And it doesn't depend just the "Type" :)

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
# @example with Validation libraly
# require 'validation'
# include validation
# list = Family.new AND(Symbol, /\A\S+\z/)
class Family

  extend Forwardable
  include Enumerable
  include Validation

  class InvalidValue < TypeError; end
  class MismatchedObject < TypeError; end
  
  class << self
    
    def multiple
      
    end
    
    private
    
    def def_enum(name)
    
      define_method name do |*args, &block|
        return to_enum(__callee__) unless block_given?
        
        @values.__send__ name, *args, &block
        self
      end

    end
    
    def def_enums(*names)
      names.each {|name|def_enum name}
    end
    
    def def_set_operator(operator)

      define_method operator do |other|
        other = other.kind_of?(::Family) ? other._values : other.to_ary
        raise MismatchedObject unless other.all?{|v|family? v}
        
        new @proof, @comparison, @values.__send__(operator, other)
      end
  
    end
    
  end
  
  attr_reader :proof, :comparison
  
  def initialize(proof, comparison=:===, values=[])
    @values, @comparison, @proof = values.to_ary, comparison, proof

    raise MismatchedObject unless valid?
  end
  
  def_enums :each, :combination
  
  def values
    @values.dup
  end
  
  alias_method :to_ary, :values
  alias_method :to_a, :values
  
  def <<(value)
    raise MismatchedObject unless family? value

    @values << value
    self
  end
  
  alias_method :push, :<<
  
  #~ def each(&block)
    #~ return to_enum(__callee__) unless block_given?

    #~ @values.each(&block)
    #~ self
  #~ end
  
  def family?(value)
    @proof.__send__ @comparison, value
  end
  
  def valid?
    @values.all?{|v|family? v}
  end
  
  def map(&block)
    new @proof, @comparison, @values.map(&block)
  end
  
  alias_method :collect, :map
  
  def map!(&block)
    return to_enum(__callee__) unless block_given?
    
    mapped_values = @values.map(&block)
    raise InvalidOperation unless mapped_values.all?{|v|family? v}
    
    @values = mapped_values
    self
  end
  
  alias_method :collect!, :map!
  
  #~ def &(other)
    #~ other = other.kind_of?(::Family) ? other._values : other.to_ary
    #~ raise MismatchedObject unless other.all?{|v|family? v}
    
    #~ new @proof, @comparison, @values & other
  #~ end
  
  def_set_operator :&
  def_set_operator :+
  def_set_operator :- # todo
  
  def *(times_or_delimiter)
    case times_or_delimiter
    when Integer
      new @proof, @comparison, @values * times_or_delimiter
    when String
      join times_or_delimiter
    else
      raise ArgumentError
    end
  end
  
  def to_family
    self
  end
  
  def freeze
    super
    @values.freeze
    self
  end
  
  def_delegators :@values, :join, :<=>, :==, :[], :at, :assoc, :rassoc
  
  def clear
    @values.clear
    self
  end
  
  def compact
    @values.compact
  end
  
  def compact!
    @values.compact! && self
  end
  
  protected
  
  def _values
    @values
  end
  
  private
  
  def initialize_copy(original)
    @values = @values.dup
  end
  
end


# coding: us-ascii

class Family

  class << self
    
    # @return [Family]
    def define(comparison: :===, values: [], &block)
      __new__ DSL.new.instance_exec(&block), comparison, values
    end

    # @private
    def __new__(proof, comparison, values)
      new proof, comparison: comparison, values: values
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
        self.class.__new__ @proof, @comparison, @values.__send__(operator, other)
      end
  
    end
    
  end
  
end

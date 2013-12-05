# coding: us-ascii

class Family

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
  
end

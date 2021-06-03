# coding: us-ascii

class Family

  class << self

    # @return [Family]
    def define(values: [], &block)
      __new__ DSL.new.instance_exec(&block), values
    end

    # @private
    def __new__(pattern, values)
      new pattern, values: values
    end

    private

    def def_enum(receiver, name)

      define_method name do |*args, &block|
        eval("#{receiver}").__send__ name, *args, &block
        self
      end

    end

    def def_enums(receiver, *names)
      names.each {|name|def_enum receiver, name}
    end

    def def_set_operator(operator)

      define_method operator do |other|
        other = other.kind_of?(::Family) ? other._values : other.to_ary
        self.class.__new__ @pattern, @values.__send__(operator, other)
      end

    end

  end

end

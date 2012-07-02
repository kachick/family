$VERBOSE = true

require_relative '../lib/family'
require 'declare'

Declare do

  The Family.new(Integer) do |list|
    is []

    The (list << 7) do
      EQUAL list
    end

    is [7]
    list << 1
    is [7, 1]
    
    The list.inspect do
      is '<Integer>[7, 1]'
    end

    The list.to_s do
      is '[7, 1]'
    end

    RESCUE Exception do
      is << 'String'
    end

    The (list & [7]) do
      is [7]
    end

    The list.dup.unshift(3) do
      is [3, 7, 1]
    end

    RESCUE Exception do
      list.unshift 3.0
    end
  end

  The Family.define{AND(String, /\d/)} do |list|
    list << '8'
    is ['8']

    RESCUE Exception do
      list << 8
    end

    RESCUE Exception do
      list << 'String'
    end
  end

end

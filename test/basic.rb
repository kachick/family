# coding: us-ascii

require_relative 'helper'

The Family.new(Integer) do |list|
  is []
  truthy list.valid?
  truthy list.family?(2)
  falthy list.family?('2')
  truthy list.similar?([2, 9])
  falthy list.similar?([2, nil])

  The (list << 7) do
    EQUAL list
  end

  is [7]
  list << 1
  is [7, 1]
  
  The list.inspect do
    is 'Family<Integer>:[7, 1]'
  end

  The list.to_s do
    is '[7, 1]'
  end

  The list.sort do
    is [1, 7]
    is list.reverse
  end

  The list.map(&:succ) do
    is [8, 2]
  end

  RESCUE Exception do
    is << 'String'
  end

  The (list & [7]) do
    is [7]
  end

  The list.dup.unshift(3) do |triple|
    is [3, 7, 1]

    The triple.values_at(0, 2) do
      is [3, 1]
    end
  end

  RESCUE Exception do
    list.unshift 3.0
  end

  truthy list.valid?
end

The Family.define{AND(String, /\d/)} do |list|
  list << '8'
  is ['8']
  truthy list.valid?

  RESCUE Exception do
    list << 8
  end

  RESCUE Exception do
    list << 'String'
  end

  is ['8']
  truthy list.valid?
  list.each(&:clear)
  is ['']
  falthy list.valid?
end

Declare.report
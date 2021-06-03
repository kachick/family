# coding: us-ascii
# frozen_string_literal: true

require_relative 'helper'

Declare.describe do
  The Family.new(Integer) do |list|
    is []
    truthy list.valid?
    truthy list.family?(2)
    falsy list.family?('2')
    truthy list.similar?([2, 9])
    falsy list.similar?([2, nil])

    The(list << 7) do
      EQUAL list
    end

    is [7]
    list << 1
    is [7, 1]

    The list.inspect do
      is 'Family<Integer>: [7, 1]'
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

    The list.map do
      KIND Enumerator
    end

    The list.size do
      is 2
    end

    The list.each.size do
      is 2
    end

    The list.map.size do
      is 2
    end

    The list.map!.size do
      is 2
    end

    CATCH ArgumentError do
      is.to_h
    end

    CATCH Family::MismatchedObject do
      list << 'String'
    end

    The(list & [7]) do
      is [7]
    end

    The(list + [3]) do
      is [7, 1, 3]
    end

    CATCH Family::MismatchedObject do
      list + [3.0]
    end

    The(list | [3]) do
      is [7, 1, 3]
    end

    CATCH Family::MismatchedObject do
      list | [3.0]
    end

    The(list - [1]) do
      is [7]
    end

    The(list - [1.0]) do
      is [7, 1]
    end

    The(list.sort.bsearch{|x| x > 4}) do
      is 7
    end

    The list.dup.unshift(3) do |triple|
      is [3, 7, 1]

      The triple.values_at(0, 2) do
        is [3, 1]
      end
    end

    CATCH Family::MismatchedObject do
      list.unshift 3.0
    end

    truthy list.valid?
  end

  The Family.new(1) do |list|
    list << 1

    CATCH Family::MismatchedObject do
      list << 2
    end

    CATCH Family::MismatchedObject do
      list << 1.1
    end

    The list.inspect do
      is 'Family<1>: [1]'
    end
  end

  The(Family.define{OR(Integer, nil)}) do |list|
    list << nil << 1 << nil << 3 << 4 << nil << nil << 7 << nil

    CATCH Family::MismatchedObject do
      list << false
    end

    The list.compact do |compact|
      KIND Family
      The compact.to_a do
        is [1, 3, 4, 7]
      end
    end
  end

  The(Family.define{AND(Array, ->ary{ary.size == 2 })}) do |list|
    list << [1, 2]

    The list.inspect do
      match(/\AFamily<AND\(Array, #<Proc:/)
    end

    CATCH Family::MismatchedObject do
      list << [1, 2, 3]
    end

    list << [10, 20]

    The list.to_h do
      is [[1, 2], [10, 20]].to_h
    end
  end

  The(Family.define{AND(String, /\d/)}) do |list|
    list << +'8'
    is ['8']
    truthy list.valid?

    CATCH Family::MismatchedObject do
      list << 8
    end

    CATCH Family::MismatchedObject do
      list << +'String'
    end

    is ['8']
    truthy list.valid?
    list.each(&:clear)
    is ['']
    falsy list.valid?
  end
end

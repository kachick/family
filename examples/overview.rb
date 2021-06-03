# coding: us-ascii
# frozen_string_literal: true

$VERBOSE = true

require_relative '../lib/family'

list = Family.new(Integer)
list << 7 #=> 7
#~ p list << 1.0 #=> Exception
list << 1 #=> 1
p list.inspect #=> "Family<Integer>: [7, 1]"

list = Family.define { AND(Float, 3..6) }
# list << 4       #=> Exception
# list << 2.0     #=> Exception
list << 4.0       #=> 4.0
p list.inspect    #=> "Family<AND(Float, 3..6)>: [4.0]"

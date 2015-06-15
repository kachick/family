# coding: us-ascii

$VERBOSE = true

require_relative '../lib/family'

list = Family.new Integer
list << 7 #=> 7
#~ p list << 1.0 #=> Exception
p list << 1 #=> 1
p list.inspect #=> Integer[7, 1]

list = Family.define { AND(Symbol, /\A\S+\z/) }
#~ list << 'k'
# list << '8' #=> Exception
p list.inspect

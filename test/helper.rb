# coding: us-ascii
# frozen_string_literal: true

$VERBOSE = true

require 'warning'

require 'irb'
require 'power_assert/colorize'
require 'irb/power_assert'

Warning[:deprecated] = true
Warning[:experimental] = true

Warning.process do |_warning|
  :raise
end

require 'declare/autorun'

require_relative '../lib/family'

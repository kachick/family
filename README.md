# family

![Build Status](https://github.com/kachick/family/actions/workflows/test_behaviors.yml/badge.svg?branch=main)
[![Gem Version](https://badge.fury.io/rb/family.svg)](http://badge.fury.io/rb/family)

Like a Typed Array, but it is more flexible than `Type`

## Usage

Require Ruby 2.7 or later

Add below code into your Gemfile

```ruby
gem 'family', '~> 0.1.0'
```

### Overview

```ruby
require 'family'
```

### Simplify

```ruby
list = Family.new Integer
list << 7      #=> 7
list << 1.0    #=> Exception
list << 1      #=> 1
list.inspect   #=> "Family<Integer>: [7, 1]
```

### Not bound by "Type"

```ruby
list = Family.new(/\A\S+\z/)
list << 'a b c' #=> Exception
list << 'abc'   #=> "abc"
list.inspect    #=> "Family</\A\S+\z/>: ["abc"]"
```

### HighLayer Definition

```ruby
list = Family.define { AND(Float, 3..6) }
list << 4       #=> Exception
list << 2.0     #=> Exception
list << 4.0     #=> 4.0
list.inspect    #=> "Family<AND(Float, 3..6)>: [4.0]"
```

The pattern builder DSL is just using [eqq](https://github.com/kachick/eqq)

## Links

* [Repository](https://github.com/kachick/family)
* [API documents](https://kachick.github.io/family/)

family
=======

[![Build Status](https://secure.travis-ci.org/kachick/family.png)](http://travis-ci.org/kachick/family)
[![Gem Version](https://badge.fury.io/rb/family.png)](http://badge.fury.io/rb/family)
[![Dependency Status](https://gemnasium.com/kachick/family.svg)](https://gemnasium.com/kachick/family)

Description
------------

Homogeneous Array

Features
--------

* The condition is not bound by "types" ... :)

Usage
-----

### To use

```ruby
require 'family'
```

### Simplify

```ruby
list = Family.new Integer
list << 7      #=> 7
list << 1.0    #=> Exception
list << 1      #=> 1
list.inspect   #=> "Integer ===: [7, 1]
```

### Not bound by "Type"

```ruby
list = Family.new /\A\S+\z/
list << 'a b c' #=> Exception
list << 'abc'   #=> "abc"
list.inspect    #=> "/\A\S+\z/ ===: ["abc"]"
```

### HighLayer Definition

```ruby
list = Family.define { AND(Float, 3..6) }
list << 4       #=> Exception
list << 2.0     #=> Exception
list << 4.0     #=> 4.0
list.inspect    #=> a Proc ===: [4.0]
```

Requirements
------------

* [Ruby 2.1 or later](http://travis-ci.org/#!/kachick/family)

Installation
-------------

```shell
$ gem install family
```

Link
----

* [code](https://github.com/kachick/family)
* [issues](https://github.com/kachick/family/issues)
* [CI](http://travis-ci.org/#!/kachick/family)
* [gem](https://rubygems.org/gems/family)

License
-------

The MIT X11 License  
Copyright (c) 2012 Kenichi Kamiya  
See MIT-LICENSE for further details.

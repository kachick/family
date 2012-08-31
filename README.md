family
=======

[![Build Status](https://secure.travis-ci.org/kachick/family.png)](http://travis-ci.org/kachick/family)

Description
------------

Homogeneous Array

Features
--------

* Not only "Type" :)

Usage
-----

### Common

```ruby
require 'family'
```

### Simplify

```ruby
list = Family.new Integer
list << 7      #=> 7
list << 1.0    #=> Exception
list << 1      #=> 1
list.inspect #=> "Family<Integer>:[7, 1]
```

### Not only "Type"

```ruby
list = Family.new /\A\S+\z/
list << 'a b c' #=> Exception
list << 'abc'   #=> "abc"
list.inspect    #=> "Family</\A\S+\z/>:["abc"]"    
```

### HighLayer Definition

```ruby
list = Family.new{AND(Symbol, /\A\S+\z/)}
```

Requirements
------------

* Ruby 1.9.2 or later [MRI/YARV, Rubinius, JRuby](http://travis-ci.org/#!/kachick/family)
* validation - 0.0.3.x

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
* [gem+](http://metagem.info/gems/family)

License
-------

The MIT X License  
Copyright (c) 2012 Kenichi Kamiya  
See the file LICENSE for further details.

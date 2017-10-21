# personnummer [![Build Status](https://secure.travis-ci.org/personnummer/ruby.png?branch=master)](http://travis-ci.org/personnummer/ruby)

Validate Swedish social security numbers.

## Installation

In your `Gemfile`

```
gem 'personnummer', :git => 'git://github.com/personnummer/ruby.git'
```

## Example

```javascript
require 'personnummer'

puts Personnummer::valid("0001010107")
// => True
```

See [test/test_personnummer.ruby](test/test_personnummer.rb) for more examples.

## License

MIT
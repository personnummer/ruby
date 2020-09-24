# personnummer [![Build Status](https://github.com/personnummer/ruby/workflows/build/badge.svg)](https://github.com/personnummer/ruby/actions)

Validate personal identity numbers.

## Installation

Add this to your `Gemfile`

```
gem 'personnummer', :git => 'https://github.com/personnummer/ruby.git'
```

Then run `bundle install`

## Example

```ruby
require 'personnummer'

puts Personnummer.valid?("8507099805")
# => True
```

See [test/test_personnummer.rb](test/test_personnummer.rb) for more examples.

## License

MIT

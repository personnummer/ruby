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

## In memoriam

Fredrik "Frozzare" Forsmo (1991-2026) was the initiator, co-founder and a core contributor of the personnummer project. This library carries his work. He is missed.

## License

MIT

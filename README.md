# personnummer [![Build Status](https://github.com/personnummer/ruby/workflows/build/badge.svg)](https://github.com/personnummer/ruby/actions)

Validate personal identity numbers.

Versions 0.x of the `personnummer` gem are a different library, [c7/personnummer](https://github.com/c7/personnummer) by Peter Hellberg, who handed the gem name over to this project. They are still on RubyGems, and a Gemfile with `gem 'personnummer', '~> 0.1'` keeps getting them. The API there is `Personnummer.new('830428-5912').valid?`, here it is `Personnummer.valid?('830428-5912')`.

## Installation

Add this to your `Gemfile`

```
gem 'personnummer'
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

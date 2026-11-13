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

Personnummer.valid?("8507099805")
# => true

pnr = Personnummer.parse("198507099805")
pnr.format         # => "850709-9805"
pnr.format(true)   # => "198507099805"
pnr.get_date.to_s  # => "1985-07-09"
pnr.get_age        # => 41 (in 2026)
pnr.is_female?     # => true
pnr.is_coord       # => false
pnr.is_interim     # => false
```

`parse` raises `Personnummer::Error` when the input is not a valid number.

### Options

`parse` and `valid?` take an options hash.

| Option                      | Default | Description                                      |
| --------------------------- | ------- | ------------------------------------------------ |
| `allow_coordination_number` | `true`  | Accept coordination numbers (samordningsnummer). |
| `allow_interim_number`      | `false` | Accept interim numbers (T-numbers).              |

```ruby
Personnummer.valid?("000101-T220")
# => false

Personnummer.valid?("000101-T220", allow_interim_number: true)
# => true

Personnummer.valid?("850769-9810", allow_coordination_number: false)
# => false
```

See [test/test_personnummer.rb](test/test_personnummer.rb) for more examples.

## In memoriam

Fredrik "Frozzare" Forsmo (1991-2026) was the initiator, co-founder and a core contributor of the personnummer project. This library carries his work. He is missed.

## License

MIT

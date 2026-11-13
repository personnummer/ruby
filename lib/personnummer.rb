# -*- encoding: utf-8 -*-
require 'date'

module Personnummer
  # Inherits from RuntimeError so existing `rescue RuntimeError` keeps working
  class Error < RuntimeError; end

  DEFAULT_OPTIONS = {
    allow_coordination_number: true,
    allow_interim_number: false
  }.freeze

  class Personnummer
    def initialize(personnummer, options={})
      parts = get_parts(personnummer)
      # Create instance variable and getter/setter for each pair in `parts` hash
      parts.each do |k,v|
        instance_variable_set("@#{k}", v)
        eigenclass = class<<self; self; end
        eigenclass.class_eval do
          attr_accessor k
        end
      end
      @options = DEFAULT_OPTIONS.merge(options || {})

      if !valid
        raise Error, "Invalid Personnummer"
      end

      if !@options[:allow_coordination_number] && is_coord
        raise Error, "Coordination numbers are not allowed"
      end

      if !@options[:allow_interim_number] && is_interim
        raise Error, "Interim numbers are not allowed"
      end
    end

    # Checks if the Personnummer is a coordination number (Samordningsnummer)
    # (TrueClass/FalseClass)
    def is_coord
      test_date(full_year, @month.to_i, @day.to_i - 60)
    end

    # Checks if the Personnummer is an interim number (T-nummer)
    # (TrueClass/FalseClass)
    def is_interim
      @num.match?(/\A[TRSUWXJKLMN]/)
    end

    # Returns the short/long formatted number
    def format(long_format=false)
      if long_format
        [@century,@year,@month,@day,@num,@check].join
      else
        [@year,@month,@day,@sep,@num,@check].join
      end
    end

    # Returns the age of the Personnummer's owner
    # (Integer)
    def get_age
      today = Time.new
      date = get_date

      return today.year - date.year - ((today.month > date.month || (today.month == date.month && today.day >= date.day)) ? 0 : 1)
    end

    # Returns the date of birth, with the 60 day offset of coordination numbers removed
    # (Date)
    def get_date
      day = @day.to_i
      day -= 60 if is_coord

      Date.new(full_year, @month.to_i, day)
    end

    # Checks if the Personnummer's owner is male
    # (TrueClass/FalseClass)
    def is_male?
      sexDigit = @num[-1].to_i
      sexDigit % 2 == 1
    end

    # Checks if the Personnummer's owner is female
    # (TrueClass/FalseClass)
    def is_female?
      !is_male?
    end

    private

    # Regex magic to split the input into parts hash.
    # Raises Error if regex is refused.
    # (Hash)
    def get_parts(personnummer)
      reg = /\A(\d{2}){0,1}(\d{2})(\d{2})(\d{2})([\+\-]?)((?!000)\d{3}|[TRSUWXJKLMN]\d{2})(\d)\z/
      match = personnummer.to_s.match(reg)

      if !match
        raise Error, "Could not parse #{personnummer} as a valid Personnummer"
      end

      century = match[1]
      year = match[2]
      month = match[3]
      day = match[4]
      sep = match[5]
      num = match[6]
      check = match[7]

      if !century
        base_year = Time.new.year
        if sep == '+'
          base_year -= 100
        else
          sep = '-'
        end
        full_year = base_year - ((base_year - year.to_i) % 100)
        century = (full_year / 100).to_s
      else
        if Time.new.year - (century + year).to_i < 100
          sep = '-'
        else
          sep = '+'
        end
      end

      return {
        century: century,
        year: year,
        month: month,
        day: day,
        sep: sep,
        num: num,
        check: check
      }
    end

    # With the century, since e.g. 1900 is not a leap year, but year 0 is.
    # (Integer)
    def full_year
      "#{@century}#{@year}".to_i
    end

    # Checks if the given values form a valid date
    # (TrueClass/FalseClass)
    def test_date(year, month, day)
      # Date.valid_date? counts negative days from the end of the month, so e.g. day 30 - 60 would pass.
      day > 0 && Date.valid_date?(year, month, day)
    end

    # Checks if the Personnummer is valid
    # (TrueClass/FalseClass)
    def valid
      if @check.length == 0
        return false
      end

      is_valid = luhn(@year + @month + @day + @num.sub(/\A[TRSUWXJKLMN]/, '1')) == @check.to_i

      if is_valid && test_date(full_year, @month.to_i, @day.to_i)
        return true
      end

      return is_valid && test_date(full_year, @month.to_i, @day.to_i - 60)
    end

    # Implementation of Luhn algorithm for calculating Personnummer checksum
    # (Integer)
    def luhn(str)
      sum = 0

      for i in 0...str.length
        v = str[i].to_i
        v *= 2 - (i % 2)
        if v > 9
          v -= 9
        end
        sum += v
      end

      ((sum.to_f / 10).ceil * 10 - sum.to_f).to_i
    end
  end

  # Return Personnummer object from given string/integer with options
  # (Personnummer)
  def self.parse(personnummer, options={})
    Personnummer.new(personnummer, options)
  end

  # Check validity of string/integer input as Personnummer
  # (TrueClass/FalseClass)
  # Anything but a hash in place of the options is the old include_coord flag
  def self.valid?(personnummer, options={})
    options = {allow_coordination_number: !!options} unless options.is_a?(Hash)

    begin
      parse(personnummer, options)
      true
    rescue Error
      false
    end
  end
end

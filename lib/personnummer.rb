# -*- encoding: utf-8 -*-
require 'date'

module Personnummer
  class Personnummer
    def initialize(personnummer, options={})
      parts = self.get_parts(personnummer)
      parts.each do |k,v|
        instance_variable_set("@#{k}", v)
        eigenclass = class<<self; self; end
        eigenclass.class_eval do
          attr_accessor k
        end
      end
      @options = options

      if !valid
        raise "Invalid Personnummer"
      end
    end

    def is_coord
      test_date(@year.to_i, @month.to_i, @day.to_i - 60)
    end

    def format(long_format=false)
      if long_format
        [@century,@year,@month,@day,@num,@check].join
      else
        [@year,@month,@day,@sep,@num,@check].join
      end
    end

    def get_age
      today = Time.new
      
      year = "#{@century}#{@year}".to_i
      month = @month.to_i
      day = @day.to_i

      if is_coord
        day -= 60
      end

      return today.year - year - ((today.month > month || (today.month == month && today.day >= day)) ? 0 : 1)
    end

    def is_male?
      sexDigit = @num[-1].to_i
      sexDigit % 2 == 1
    end

    def is_female?
      !is_male?
    end

    private

    def get_parts(personnummer)
      reg = /^(\d{2}){0,1}(\d{2})(\d{2})(\d{2})([\-|\+]{0,1})?(\d{3})(\d{0,1})$/;
      match = personnummer.to_s.match(reg)

      if !match
        raise "Could not parse #{personnummer} as a valid Personnummer"
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

    def test_date(year, month, day)
      begin
        date = Date.new(year, month, day)
        return !(date.year != year || date.month != month || date.day != day)
      rescue Date::Error, TypeError
        false
      end
    end
    
    def valid
      if @check.length == 0
        return false
      end

      is_valid = luhn(@year + @month + @day + @num) == @check.to_i

      if is_valid && test_date(@year.to_i, @month.to_i, @day.to_i)
        return true
      end

      return is_valid && test_date(@year.to_i, @month.to_i, @day.to_i - 60)
    end

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


  def self.parse(personnummer, options={})
    Personnummer.new(personnummer, options={})
  end

  def self.valid?(personnummer, include_coord=true)
    begin
      nummer = parse(personnummer)
      if !include_coord && nummer.is_coord
        return false
      end
      true
    rescue RuntimeError
      false
    end
  end
end

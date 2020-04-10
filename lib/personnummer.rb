# -*- encoding: utf-8 -*-
require 'date'

class Personnummer
    # luhn will test if the given string is a valid luhn string.
    def self.luhn(str)
        v = 0
        sum = 0

        for i in 0...str.length
            v = str[i].to_i
            v *= 2 - (i % 2)
            if v > 9
                v -= 9
            end
            sum += v
        end

        return ((sum.to_f / 10).ceil * 10 - sum.to_f).to_i
    end

    # test_date will test if date is valid or not.
    def self.test_date(year, month, day)
        begin
            date = Date.new(year, month, day)
            return !(date.year != year || date.month != month || date.mday != day)
        rescue ArgumentError
            return false
        end
    end

    # valid will validate Swedish social security numbers.
    def self.valid(str)
        if !str.respond_to?(:to_s) || !str.respond_to?(:to_i)
            return false
        end

        reg = /^(\d{2}){0,1}(\d{2})(\d{2})(\d{2})([\-|\+]{0,1})?(\d{3})(\d{0,1})$/;
        match = str.to_s.match(reg)

        if !match
            return false
        end

        year    = match[2]
        month   = match[3]
        day     = match[4]
        sep     = match[5]
        num     = match[6]
        check   = match[7]

        if sep.to_s.empty?
            sep = '-'
        end

        valid = self.luhn(year + month + day + num) == check.to_i && !!check

        if valid && self.test_date(year.to_i, month.to_i, day.to_i)
            return valid
        end

        return valid && self.test_date(year.to_i, month.to_i, day.to_i - 60)
    end

    def self.get_parts(input)
      input = input.to_s

      reg = /^(\d{2}){0,1}(\d{2})(\d{2})(\d{2})([\-|\+]{0,1})?(\d{3})(\d{0,1})$/;
      match = reg.match(input)
      century = match[1]
      year = match[2]
      month = match[3]
      day = match[4]
      sep = match[5]
      num = match[6]
      check = match[7]

      if !(sep == '-' || sep == '+')
        if (( century.nil? || !century.length) || Time.new.year - (century + year).to_i < 100)
          sep = '-'
        else
          sep = '+'
        end
      end

      if (century.nil? || !century.length)
        d = Time.new
        base_year = 0

        if sep == '+'
          base_year = d.year - 100
        else
          base_year = d.year
        end
        century = (base_year - ((base_year - year.to_i) % 100)).digits[-2..-1].reverse.join('').to_s
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

    def self.get_age(input, include_coordination_number = true)
      if !self.valid(input)
        return false
      end

      parts = self.get_parts(input)
      century = parts[:century].to_i
      year = parts[:year].to_i
      month = parts[:month].to_i
      day = parts[:day].to_i

      if include_coordination_number && day >= 61 && day < 91
        day -= 60
      end

      now = Time.now.utc.to_date
      dob = Date.parse("#{century}#{year}-#{month}-#{day}")
      now.year - dob.year - ((now.month > dob.month || (now.month == dob.month && now.day >= dob.day)) ? 0 : 1)
    end

    def self.format(input, long_format=false)
      if !self.valid(input)
        return false
      end

      parts = self.get_parts(input)

      parts.delete(long_format ? :sep : :century)
      parts.values.join
    end
end

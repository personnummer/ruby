require 'minitest/autorun'
require 'timecop'
require 'personnummer'

class PersonnummerTest < Minitest::Test
    def test_with_control_digit
        assert_equal true, Personnummer::valid?(8507099805)
        assert_equal true, Personnummer::valid?('198507099805')
        assert_equal true, Personnummer::valid?('198507099813')
        assert_equal true, Personnummer::valid?('850709-9813')
        assert_equal true, Personnummer::valid?('196411139808')
        assert_equal false, Personnummer::valid?('19090527 1474')
    end

    def test_without_control_digit
        assert_equal false, Personnummer::valid?('19850709980')
        assert_equal false, Personnummer::valid?('19850709981')
        assert_equal false, Personnummer::valid?('19641113980')
    end

    def test_wrong_personnummer_or_types
        assert_equal false, Personnummer::valid?(nil)
        assert_equal false, Personnummer::valid?([])
        assert_equal false, Personnummer::valid?({})
        assert_equal false, Personnummer::valid?(false)
        assert_equal false, Personnummer::valid?(true)
        assert_equal false, Personnummer::valid?(0)
        assert_equal false, Personnummer::valid?('112233-4455')
        assert_equal false, Personnummer::valid?('19112233-4455')
        assert_equal false, Personnummer::valid?('20112233-4455')
        assert_equal false, Personnummer::valid?('9999999999')
        assert_equal false, Personnummer::valid?('199999999999')
        assert_equal false, Personnummer::valid?('199909193776')
        assert_equal false, Personnummer::valid?('Just a string')
        assert_equal false, Personnummer::valid?('990919+3776')
        assert_equal false, Personnummer::valid?('990919-3776')
        assert_equal false, Personnummer::valid?('9909193776')
        assert_equal false, Personnummer::valid?('20150916-0006')
    end

    def test_coordination_numbers
        assert_equal true, Personnummer::valid?('198507699802')
        assert_equal false, Personnummer::valid?('850769-9802', false)
        assert_equal false, Personnummer::valid?('198507699810', false)
        assert_equal true, Personnummer::valid?('850769-9810')
    end

    def test_wrong_coordination_numbers
        assert_equal false, Personnummer::valid?('900161-0017', false)
        assert_equal false, Personnummer::valid?('640893-3231')
        assert_equal false, Personnummer::valid?('750232-4630')
    end

    def test_is_coord
        assert_equal true, Personnummer.parse('850769-9810').is_coord
        assert_equal false, Personnummer.parse('850709-9813').is_coord
        assert_equal false, Personnummer.parse('750330-4631').is_coord
    end

    def test_leap_days
        # 2000 is a leap year.
        assert_equal true, Personnummer::valid?('20000229-1540')
        assert_equal true, Personnummer::valid?('000229-1540')
        assert_equal true, Personnummer::valid?('20000289-1547')

        # 1900 is not.
        assert_equal false, Personnummer::valid?('19000229-1540')
        assert_equal false, Personnummer::valid?('000229+1540')
        assert_equal false, Personnummer::valid?('19000289-1547')
    end

    def test_format
      assert_equal '640327-3813', Personnummer.parse(6403273813).format
      assert_equal '510818-9167', Personnummer.parse('510818-9167').format
      assert_equal '900101-0017', Personnummer.parse('19900101-0017').format
      assert_equal '130401+2931', Personnummer.parse('19130401+2931').format
      assert_equal '640823-3234', Personnummer.parse('196408233234').format
      assert_equal '000101-0107', Personnummer.parse('0001010107').format
      assert_equal '000101-0107', Personnummer.parse('000101-0107').format
      assert_equal '130401+2931', Personnummer.parse('191304012931').format
      assert_equal '196403273813', Personnummer.parse(6403273813).format(true)
      assert_equal '195108189167', Personnummer.parse('510818-9167').format(true)
      assert_equal '199001010017', Personnummer.parse('19900101-0017').format(true)
      assert_equal '191304012931', Personnummer.parse('19130401+2931').format(true)
      assert_equal '196408233234', Personnummer.parse('196408233234').format(true)
      assert_equal '200001010107', Personnummer.parse('0001010107').format(true)
      assert_equal '200001010107', Personnummer.parse('000101-0107').format(true)
      assert_equal '190001010107', Personnummer.parse('000101+0107').format(true)
    end

    def test_get_age
      Timecop.freeze(Time.utc(2020, "May", 1, 9, 0,0)) do
        assert_equal 34, Personnummer.parse('198507099805').get_age
        assert_equal 34, Personnummer.parse('198507099813').get_age
        assert_equal 55, Personnummer.parse('196411139808').get_age
        assert_equal 107, Personnummer.parse('19121212+1212').get_age
        assert_equal 34, Personnummer.parse('198507699810').get_age
        assert_equal 34, Personnummer.parse('198507699802').get_age
      end
    end

    def test_is_male
      assert_equal false, Personnummer.parse('198507099805').is_male?
      assert_equal true, Personnummer.parse('198507099813').is_male?
      assert_equal false, Personnummer.parse('196411139808').is_male?
      assert_equal true, Personnummer.parse('19121212+1212').is_male?
      assert_equal true, Personnummer.parse('198507699810').is_male?
      assert_equal false, Personnummer.parse('198507699802').is_male?
    end

    def test_is_female
      assert_equal true, Personnummer.parse('198507099805').is_female?
      assert_equal false, Personnummer.parse('198507099813').is_female?
      assert_equal true, Personnummer.parse('196411139808').is_female?
      assert_equal false, Personnummer.parse('19121212+1212').is_female?
      assert_equal false, Personnummer.parse('198507699810').is_female?
      assert_equal true, Personnummer.parse('198507699802').is_female?
    end

    INTERIM_LETTERS = %w[T R S U W X J K L M N]
    INTERIM_OPTS = {allow_interim_number: true}

    def test_interim_valid_with_option
      INTERIM_LETTERS.each do |l|
        ["20000101#{l}220", "000101#{l}220", "000101-#{l}220", "20000101-#{l}220"].each do |n|
          assert_equal true, Personnummer.valid?(n, INTERIM_OPTS), n
        end
      end
      assert_equal false, Personnummer.valid?('20000101E221', INTERIM_OPTS)
      assert_equal false, Personnummer.valid?('000101-E221', INTERIM_OPTS)
    end

    def test_interim_rejected_by_default
      INTERIM_LETTERS.each do |l|
        assert_equal false, Personnummer.valid?("20000101#{l}220"), l
        assert_equal false, Personnummer.valid?("000101-#{l}220"), l
        assert_equal false, Personnummer.valid?("000101-#{l}220", allow_interim_number: false), l
        assert_raises(Personnummer::Error) { Personnummer.parse("000101-#{l}220") }
      end
    end

    def test_interim_format
      INTERIM_LETTERS.each do |l|
        ["20000101#{l}220", "000101#{l}220", "000101-#{l}220", "20000101-#{l}220"].each do |n|
          p = Personnummer.parse(n, INTERIM_OPTS)
          assert_equal "000101-#{l}220", p.format, n
          assert_equal "20000101#{l}220", p.format(true), n
        end
      end
    end

    def test_is_interim
      INTERIM_LETTERS.each do |l|
        assert_equal true, Personnummer.parse("20000101#{l}220", INTERIM_OPTS).is_interim
      end
      assert_equal false, Personnummer.parse('850709-9813').is_interim
      assert_equal false, Personnummer.parse('850769-9810').is_interim
    end

    def test_interim_sex
      assert_equal true, Personnummer.parse('000101-T220', INTERIM_OPTS).is_female?
      assert_equal false, Personnummer.parse('000101-T220', INTERIM_OPTS).is_male?
    end

    def test_get_date
      assert_equal Date.new(1985, 7, 9), Personnummer.parse('198507099805').get_date
      assert_equal Date.new(1985, 7, 9), Personnummer.parse('850709-9813').get_date
      assert_equal Date.new(1985, 7, 9), Personnummer.parse('198507699810').get_date
      assert_equal Date.new(2000, 1, 1), Personnummer.parse('000101-T220', INTERIM_OPTS).get_date
    end

    def test_get_age_interim
      Timecop.freeze(Time.utc(2020, "May", 1, 9, 0, 0)) do
        assert_equal 20, Personnummer.parse('000101-T220', INTERIM_OPTS).get_age
      end
    end

    def test_option_allow_coordination_number
      assert_equal true, Personnummer.valid?('850769-9810', allow_coordination_number: true)
      assert_equal false, Personnummer.valid?('850769-9810', allow_coordination_number: false)
      assert_equal true, Personnummer.valid?('850709-9813', allow_coordination_number: false)
      assert_equal true, Personnummer.parse('850769-9810').is_coord
      assert_equal true, Personnummer.parse('850769-9810', allow_coordination_number: true).is_coord
      assert_raises(Personnummer::Error) { Personnummer.parse('850769-9810', allow_coordination_number: false) }
      assert_raises(Personnummer::Error) { Personnummer::Personnummer.new('850769-9810', allow_coordination_number: false) }
      assert_equal false, Personnummer.parse('850709-9813', allow_coordination_number: false).is_coord
    end

    def test_option_allow_interim_number
      assert_equal true, Personnummer.valid?('000101-T220', allow_interim_number: true)
      assert_equal false, Personnummer.valid?('000101-T220', allow_interim_number: false)
      assert_equal true, Personnummer.parse('000101-T220', allow_interim_number: true).is_interim
      assert_raises(Personnummer::Error) { Personnummer::Personnummer.new('000101-T220') }
      assert_equal true, Personnummer.valid?('850709-9813', allow_interim_number: true)
      # Options combine
      assert_equal true, Personnummer.valid?('000101-T220', allow_interim_number: true, allow_coordination_number: false)
      assert_equal false, Personnummer.valid?('850769-9810', allow_interim_number: true, allow_coordination_number: false)
    end

    def test_valid_boolean_form
      assert_equal true, Personnummer.valid?('850769-9810', true)
      assert_equal false, Personnummer.valid?('850769-9810', false)
      assert_equal true, Personnummer.valid?('850709-9813', false)
      assert_equal false, Personnummer.valid?('000101-T220', true)
      # The old flag was only tested for truthiness, and valid? must never raise.
      assert_equal false, Personnummer.valid?('850769-9810', nil)
      assert_equal true, Personnummer.valid?('850769-9810', 'yes')
    end

    def test_anchoring
      assert_equal false, Personnummer.valid?('xx8507099805yy')
      assert_equal false, Personnummer.valid?('xx198507099805')
      assert_equal false, Personnummer.valid?('198507099805yy')
      assert_equal false, Personnummer.valid?(" 198507099805")
      assert_equal false, Personnummer.valid?("198507099805\n")
      assert_equal false, Personnummer.valid?("x000101-T220", INTERIM_OPTS)
      assert_equal false, Personnummer.valid?("000101-T220x", INTERIM_OPTS)
    end

    def test_error_class
      assert_operator Personnummer::Error, :<, RuntimeError
      error = assert_raises(Personnummer::Error) { Personnummer.parse('Just a string') }
      assert_equal 'Could not parse Just a string as a valid Personnummer', error.message
      error = assert_raises(Personnummer::Error) { Personnummer.parse('990919-3776') }
      assert_equal 'Invalid Personnummer', error.message
      assert_raises(RuntimeError) { Personnummer.parse('990919-3776') }
    end
end

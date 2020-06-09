require 'minitest/autorun'
require 'personnummer'

class PersonnummerTest < Minitest::Test
    def test_with_control_digit
        assert_equal true, Personnummer::valid?(8507099805)
        assert_equal true, Personnummer::valid?('198507099805')
        assert_equal true, Personnummer::valid?('198507099813')
        assert_equal true, Personnummer::valid?('850709-9813')
        assert_equal true, Personnummer::valid?('196411139808')
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
      Time.stub :now, Time.utc(2020, "May", 1, 9, 0,0) do
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
end

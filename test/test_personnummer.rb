require 'minitest/autorun'
require 'personnummer'

class PersonnummerTest < Minitest::Test
    def test_with_control_digit
        assert_equal true, Personnummer::valid(8507099805)
        assert_equal true, Personnummer::valid('198507099805')
        assert_equal true, Personnummer::valid('198507099813')
        assert_equal true, Personnummer::valid('850709-9813')
        assert_equal true, Personnummer::valid('196411139808')
    end

    def test_without_control_digit
        assert_equal false, Personnummer::valid('19850709980')
        assert_equal false, Personnummer::valid('19850709981')
        assert_equal false, Personnummer::valid('19641113980')
    end

    def test_wrong_personnummer_or_types
        assert_equal false, Personnummer::valid(nil)
        assert_equal false, Personnummer::valid([])
        assert_equal false, Personnummer::valid({})
        assert_equal false, Personnummer::valid(false)
        assert_equal false, Personnummer::valid(true)
        assert_equal false, Personnummer::valid(0)
        assert_equal false, Personnummer::valid('112233-4455')
        assert_equal false, Personnummer::valid('19112233-4455')
        assert_equal false, Personnummer::valid('20112233-4455')
        assert_equal false, Personnummer::valid('9999999999')
        assert_equal false, Personnummer::valid('199999999999')
        assert_equal false, Personnummer::valid('199909193776')
        assert_equal false, Personnummer::valid('Just a string')
        assert_equal false, Personnummer::valid('990919+3776')
        assert_equal false, Personnummer::valid('990919-3776')
        assert_equal false, Personnummer::valid('9909193776')
    end

    def test_coordination_numbers
        assert_equal true, Personnummer::valid('198507699802')
        assert_equal true, Personnummer::valid('850769-9802')
        assert_equal true, Personnummer::valid('198507699810')
        assert_equal true, Personnummer::valid('850769-9810')
    end

    def test_wrong_coordination_numbers
        assert_equal false, Personnummer::valid('900161-0017')
        assert_equal false, Personnummer::valid('640893-3231')
    end
end
require 'minitest/autorun'
require 'personnummer'

class PersonnummerTest < Minitest::Test
    def test_with_control_digit
        assert_equal true, Personnummer::valid(6403273813)
        assert_equal true, Personnummer::valid('510818-9167')
        assert_equal true, Personnummer::valid('19900101-0017')
        assert_equal true, Personnummer::valid('19130401+2931')
        assert_equal true, Personnummer::valid('196408233234')
        assert_equal true, Personnummer::valid('000101-0107')
        assert_equal true, Personnummer::valid('0001010107')
    end

    def test_without_control_digit
        assert_equal false, Personnummer::valid(640327381)
        assert_equal false, Personnummer::valid('510818-916')
        assert_equal false, Personnummer::valid('19900101-001')
        assert_equal false, Personnummer::valid('100101+001')
    end

    def test_wrong_personnummer_or_types
        assert_equal false, Personnummer::valid(nil)
        assert_equal false, Personnummer::valid([])
        assert_equal false, Personnummer::valid({})
        assert_equal false, Personnummer::valid(false)
        assert_equal false, Personnummer::valid(true)
        assert_equal false, Personnummer::valid(1122334455)
        assert_equal false, Personnummer::valid('112233-4455')
        assert_equal false, Personnummer::valid('19112233-4455')
        assert_equal false, Personnummer::valid('9999999999')
        assert_equal false, Personnummer::valid('199999999999')
        assert_equal false, Personnummer::valid('9913131315')
        assert_equal false, Personnummer::valid('9911311232')
        assert_equal false, Personnummer::valid('9902291237')
        assert_equal false, Personnummer::valid('19990919_3766')
        assert_equal false, Personnummer::valid('990919_3766')
        assert_equal false, Personnummer::valid('199909193776')
        assert_equal false, Personnummer::valid('Just a string')
        assert_equal false, Personnummer::valid('990919+3776')
        assert_equal false, Personnummer::valid('990919-3776')
        assert_equal false, Personnummer::valid('9909193776')
    end

    def test_coordination_numbers
        assert_equal true, Personnummer::valid('701063-2391')
        assert_equal true, Personnummer::valid('640883-3231')
    end

    def test_wrong_coordination_numbers
        assert_equal false, Personnummer::valid('900161-0017')
        assert_equal false, Personnummer::valid('640893-3231')
    end
end
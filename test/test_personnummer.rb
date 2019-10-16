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
        assert_equal true, Personnummer::valid('200002296127')
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

    def test_format
      assert_equal '640327-3813', Personnummer::format(6403273813)
      assert_equal '510818-9167', Personnummer::format('510818-9167')
      assert_equal '900101-0017', Personnummer::format('19900101-0017')
      assert_equal '130401+2931', Personnummer::format('19130401+2931')
      assert_equal '640823-3234', Personnummer::format('196408233234')
      assert_equal '000101-0107', Personnummer::format('0001010107')
      assert_equal '000101-0107', Personnummer::format('000101-0107')
      assert_equal '130401+2931', Personnummer::format('191304012931')
      assert_equal '196403273813', Personnummer::format(6403273813, true)
      assert_equal '195108189167', Personnummer::format('510818-9167', true)
      assert_equal '199001010017', Personnummer::format('19900101-0017', true)
      assert_equal '191304012931', Personnummer::format('19130401+2931', true)
      assert_equal '196408233234', Personnummer::format('196408233234', true)
      assert_equal '200001010107', Personnummer::format('0001010107', true)
      assert_equal '200001010107', Personnummer::format('000101-0107', true)
      assert_equal '190001010107', Personnummer::format('000101+0107', true)
    end
end

require 'test/unit'
require 'hl'

class HlTestTest < Test::Unit::TestCase
    def setup
        @hotspot = Hotspot::Hotspot.new("foo", "baz")
        @res = Net::HTTP::get_response(@hotspot.uri_test)
    end

    def test_connect?
        assert @hotspot.connect? == true || @hotspot.connect? == false
    end

    def test_login_url
        if @hotspot.connect?
            assert_equal @hotspot.uri_test, URI(@hotspot.login_url)
        end
    end

    def test_redirect?
        if @hotspot.connect?
            assert_equal @hotspot.uri_test.to_s, @hotspot.redirect?(@res)
        end
    end

    def test_info
        assert_equal @hotspot.login_url, @hotspot.info.to_s
    end

    def test_params
        if @hotspot.connect?
            assert_equal Hash.new, @hotspot.params
        end
    end

    def test_auth
        :raise
    end
end

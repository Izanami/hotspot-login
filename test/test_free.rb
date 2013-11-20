require 'test/unit'
require 'hl'

class HlTestSfr < Test::Unit::TestCase
    def setup
        @hotspot = Hotspot::FreeWifi.new("foo", "baz")
        @res = Net::HTTP::get_response(@hotspot.uri_test)
        @login_url = "https://wifi.free.fr/?url=http://example.iana.org/"
        @free = @hotspot.free?
    end

    def test_login_url
        if @free
            assert_equal URI(@login_url), URI(@hotspot.login_url)
        end
    end

    def test_redirect?
        if @free
            assert_equal @login_url, @hotspot.redirect?(@res)
        end
    end
end

require "minitest/autorun"
require 'hl'

class HlTestFree < Minitest::Test
    def setup
        @hotspot = Hotspot::FreeWifi.new("foo", "baz")
        @res = Net::HTTP::get_response(URI(@hotspot.uri_test))
        @login_url = "https://wifi.free.fr/?url=http://www.example.org"
        @free = @hotspot.hotspot?
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

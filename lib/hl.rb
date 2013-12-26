require 'net/http'
require 'cgi'

module Hotspot
class Hotspot
    def initialize(user, password)
        @uri_test = URI("http://www.example.com")
        @user = user
        @password = password
        login_url
    end

    # Check connection to internet
    def connect?
        redirect = redirect? Net::HTTP.get_response(@uri_test)
        redirect == @uri_test.to_s
    end

    # Get the url of login hotspot
    def login_url
        login_url! if @login_url.nil?
        @login_url
    end

    # Force login_url
    def login_url!
        @login_url = redirect? Net::HTTP.get_response(@uri_test)
    end

    # Get the the forwarding url
    def redirect?(res)
        case res
        when Net::HTTPSuccess then
            javascript = /window\.location = \"(.*)\"/m.match(res.body)
            if not javascript.nil?
                javascript[1]
            else
                res.uri.to_s
            end
        when Net::HTTPRedirection then
            res['location']
        else
            raise
        end
    end

    # Return login url
    def info
        URI.parse(login_url)
    end

    # Return params of login url
    def params
        if not info.query.nil?
            CGI::parse(info.query)
        else
            Hash.new
        end
    end

    # Return uri test to test connect
    def uri_test
        @uri_test
    end

    def auth
        raise
    end

    def get(uri)
        Net::HTTP.get_response(URI(uri))
    end

    def post(uri, query)
        Net::HTTP.post_form(URI(uri), query)
    end

    def sfr?
        info.host == "hotspot.wifi.sfr.fr"
    end

    def uppa?
        info.host == "wism.univ-pau.fr"
    end

    def free?
        info.host == "wifi.free.fr"
    end
end

class Sfr < Hotspot
    def hotspot?
        sfr?
    end

    def auth
        query = params.merge!({username: @user, username2: @user, password: @password, conditions: "on", lang: "fr", connexion: "Connexion", accessType: "neuf"})
        t = redirect? post("https://hotspot.wifi.sfr.fr/nb4_crypt.php", query)
        get(t)
    end
end

class UPPA < Hotspot
    def hotspot?
        uppa?
    end

    def auth
        query = params.merge!({username: @user, password: @password, buttonClicked: 4, info_msg:nil, info_flag: 0, err_msg: nil, err_flag: 0})
        post("https://wism.univ-pau.fr/login.html", query)
    end
end

class FreeWifi < Hotspot
    def hotspot?
        free?
    end

    def auth
        query = params.merge!({login: @user, password: @password, submit: "Valider"})
        post("https://wifi.free.fr/Auth", query)
    end
end

end

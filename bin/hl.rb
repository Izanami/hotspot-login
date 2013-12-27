#!/usr/bin/env ruby
require 'yaml'
require 'optparse'
require 'hl'

class Hotspot_Login
    def parse
        @options = parse!(ARGV) if @options.nil?
        @options
    end

    def parse!(args)
        options = {verbose: false, hotspot: nil}

        opt_parser = OptionParser.new do |opts|
            opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
                options[:verbose] = true
            end

            opts.on("-h", "--hotspot HOTSPOT", "Hotspot: Sfr or FreeWifi or UPPA") do |hotspot|
                options[:hotspot] = hotspot
            end

            opts.on("-u", "--user USER", "User") do |user|
                options[:user] = user
            end

            opts.on("-p", "--password PASSWORD","Password") do |password|
                options[:password] = password
            end
        end

        opt_parser.parse!(args)
        @options = options
    end

    def config
        @config = config! if @config.nil?
        @config
    end

    def config!
        config =  Hash.new

        Hotspot::Hotspot.hotspots.each do |hotspot, val|
            config[hotspot] = {type: hotspot}
        end

        path = Dir.home + "/.config/hl.yml"

        if not File.exists? path
            if File.exists? "/etc/hl.yml"
                path = "/etc/hl.yml"
            else
                open(path, 'w') do |f|
                    f.puts "# profile:\n"
                    f.puts "#  :hotspot: sfr or free or uppa\n"
                    f.puts "#  :user:\n"
                    f.puts "#  :password:\n"
                    f.puts "profile: null:\n"
                end
            end
        end

        file = File.open(path)
        config.merge! YAML.load(file)
    end

    def connect
        connected = false
        hotspot = parse[:hotspot]
        if not hotspot.nil?
            raise "Not found config hotspot: #{hotspot}" if config[hotspot].nil?
            connected =  connect! config[hotspot].merge!(parse)
        else
            config.each do |hotspot, params|
                if connect! params.merge!(parse)
                    connected = true
                    break
                end
            end
        end

        if connected
            puts "Connected"
            true
        else
            puts "Not connected"
            false
        end
    end

    def connect!(config)
        engine = engine?(config[:type])
        hotspot = engine.new(config[:user], config[:password])

        raise "Already connected" if hotspot.connect?
        return false if not hotspot.hotspot?

        hotspot.auth
        hotspot.connect?
    end

    def engine?(type)
        Hotspot::Hotspot.hotspots[type]
    end
end

Hotspot_Login.new.connect

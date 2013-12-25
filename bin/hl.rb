#!/usr/bin/env ruby
require 'yaml'
require 'optparse'
require 'hl'

class Hotspot_Login
    def initialize
        @engine = {
            "sfr" => Hotspot::Sfr,
            "free" => Hotspot::FreeWifi
            }
    end

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

            opts.on("-h", "--hotspot HOTSPOT", "Hotspot") do |hotspot|
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
        config =  {
            "sfr" => {type: "sfr"},
            "free" => {type: "free"}
        }

        file = File.open(Dir.home + "/.config/hl.yml")
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
        @engine[type]
    end
end

Hotspot_Login.new.connect

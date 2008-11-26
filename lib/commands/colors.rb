Leafman::Command.new "colors", "on|off", "set ANSI colors on or off" do |opt|
    include Leafman::Mixin
    @config['colors'] = ((opt =~ /^on$/i) ? true : false)
end

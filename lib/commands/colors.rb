Leafman::Command.new "colors", "on|off", "set ANSI colors on or off", "configuration" do |opt|
    include Leafman::Mixin
    Leafman.config['colors'] = ((opt =~ /^on$/i) ? true : false)
end

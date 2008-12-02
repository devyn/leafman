Leafman::Command.new "web-show-files", "on|off", "sets the ability to show the files in a project on the web interface" do |opt|
    include Leafman::Mixin
    Leafman.config['web_show_files'] = ((opt =~ /^on$/i) ? true : false)
end

Leafman::Command.new "show-revision", "on|off", "in show and web interfaces, set showing the current revision on/off. do not turn this on unless necessary, because it slows it down." do |opt|
    include Leafman::Mixin
    Leafman.config['show_revision'] = ((opt =~ /^on$/i) ? true : false)
end

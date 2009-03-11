module Leafman
    COMMANDS = []
    class Command
        attr :name
        attr :help_args
        attr :help_comment
        attr :kind
        attr :block
        def initialize(_name, _help_args, _help_comment, _kind='general', &_block)
            @name         = _name
            @help_args    = _help_args
            @help_comment = _help_comment
            @kind         = _kind
            @block        = _block
            Leafman::COMMANDS << self
        end
    end
    def get_command(name)
        COMMANDS.select{|c|c.name =~ /^#{Regexp.escape(name)}$/i }[0]
    end
    def parse_args(*argv)
        @config = {}
        load_conf rescue Leafman::Mixin.warning("couldn't load the config file; ignore this if you are running INIT")
        cn = argv.shift
        if cn.empty?
	    c = get_command('help')
	else
            c = get_command(cn)
	end
        return Leafman::Mixin.error("invalid command") unless c
        c.block.call(*argv) rescue Leafman::Mixin.error("#{$!.class.name}: #{$!.message}")
        save_conf
    end
end

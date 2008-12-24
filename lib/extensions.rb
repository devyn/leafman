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
        load_conf rescue warn("\e[33mcouldn't load the config file; ignore this if you are running INIT\e[0m")
        c = get_command(argv.shift)
        return warn("\e[31m\e[1minvalid command\e[0m") unless c
        c.block.call(*argv) rescue puts("\e[1m\e[31mERROR: \e[0m\e[31m#{$!.message}\e[0m")
        save_conf
    end
end

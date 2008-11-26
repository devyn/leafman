module Leafman
    COMMANDS = []
    class Command
        attr :name
        attr :help_args
        attr :help_comment
        attr :block
        def initialize(_name, _help_args, _help_comment, &_block)
            @name = _name
            @help_args = _help_args
            @help_comment = _help_comment
            @block = _block
            Leafman::COMMANDS << self
        end
    end
    def get_command(name)
        COMMANDS.select{|c|c.name =~ /^#{Regexp.escape(name)}$/i }[0]
    end
    def parse_args(*argv)
        load_conf rescue warn("\e[33mcouldn't load the config file; ignore this if you are running INIT\e[0m")
        c = get_command(argv.shift)
        abort "\e[31m\e[1minvalid command\e[0m" unless c
        c.block.call(*argv)
        save_conf
    end
end

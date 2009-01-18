# Unified color scheme for Leafman.
# Edit as you wish.
module Leafman::Mixin
    def title s
        puts ":: \e[34m\e[1m#{s}\e[0m"
    end
    def task s
        puts ":: \e[36m\e[1m#{s}\e[0m"
    end
    def command s
        puts ">>     \e[33m#{s}\e[0m"
    end
    def warning s
        warn "!!     \e[1m\e[33m#{s}\e[0m"
    end
    def error s
        warn "!! \e[1m\e[31m#{s}\e[0m"
    end
    def list_item s, bullet="**"
        puts "\e[1m#{bullet}\e[0m        #{s}"
    end
    def log s
        puts "::     #{s}"
    end
    def ask s
        puts "??     \e[36m#{s}\e[0m"
    end
    def finished
        puts ":: \e[32m\e[1mdone!\e[0m"
    end
end

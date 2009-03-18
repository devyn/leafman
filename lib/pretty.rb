# Unified color scheme for Leafman.
# Edit as you wish.
module Leafman::Mixin
    extend self
    def title s
        self.xterm_title = "Leafman - #{s}"
        puts ":: \e[34m\e[1m#{s}\e[0m"
    end
    def xterm_title= s
        print "\033]0;#{s}\007"
    end
    def task s
        puts ":: \e[36m\e[1m#{s}\e[0m"
    end
    def command s
        puts ">>     \e[1m\e[33m#{s}\e[0m"
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
    def command_log s
        puts "::         \e[33m#{s}\e[0m"
    end
    def ask s
        puts "??     \e[36m#{s}\e[0m"
    end
    def finished
        puts ":: \e[32m\e[1mdone!\e[0m"
    end
    def run_command c, *a
        command [c, *a].collect{|sg| sg.include?(" ") ? "\"#{sg}\"" : sg}.collect{|sg|(sg.size > 50)||(sg.include?("\n")) ? '...' : sg}.join(" ")
        IO.popen([c, *a].collect{|sg|"\"#{sg.gsub("\\", "\\\\").gsub("\"", "\\\"")}\""}.join(" "), 'r') do |pr|
            pr.each_line do |ln|
                command_log ln.chomp
            end
        end
        $?.success?
    end
end

Leafman::Command.new "help", "", "show a complete command list" do
    include Leafman::Mixin
    puts "\e[1m\e[31mL \e[32mE \e[33mA \e[31mF \e[32mM \e[33mA \e[31mN\e[0m  #{Leafman::VERSION}, the \e[32mLEAF\e[0m way to get stuff done!"
    puts "\e[1m\e[34musage:\e[0m #{$0} <command> [parameters...]"
    puts
    puts "\e[1m\e[34mcommand list:\e[0m"
    Leafman::COMMANDS.each do |c|
        puts "\t\e[1m#{c.name}\e[0m #{c.help_args} \e[33m# #{c.help_comment}\e[0m"
    end
    puts
    puts "\e[1m\e[34mcreated by ~devyn\e[0m"
end

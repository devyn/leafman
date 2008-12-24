Leafman::Command.new "help", "[command-name]", "show a complete command list" do |*a|
    include Leafman::Mixin
    if a[0]
        puts File.read(File.join(File.dirname(File.dirname(File.dirname(__FILE__))), "man", a[0]))
    else
        puts "\e[1m\e[31mL \e[32mE \e[33mA \e[31mF \e[32mM \e[33mA \e[31mN\e[0m  #{Leafman::VERSION}, the \e[32mLEAF\e[0m way to get stuff done!"
        puts "\e[1m\e[34musage:\e[0m #{$0} <command> [parameters...]"
        puts
        ckinds = Hash.new {|hash, key| hash[key] = ""}
        Leafman::COMMANDS.each do |c|
            ckinds[c.kind.downcase] << "\t\e[1m#{c.name}\e[0m #{c.help_args} \e[33m# #{c.help_comment}\e[0m\n"
        end
        ckinds.each do |kind, cs|
            puts "\e[1m\e[34m#{kind}:\e[0m"
            puts cs
            puts
        end
        puts "\e[1m\e[34mcreated by ~devyn\e[0m"
    end
end

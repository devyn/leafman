Leafman::Command.new "skel-ruby", "<project-name> [classes]", "generate a Ruby skeleton (with class skeletons) for <project-name>, then set the 'type' accordingly" do |pname, classes|
    include Leafman::Mixin
    puts "\e[1mskel-ruby:\e[0m #{pname}"
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    puts "\e[1mappend a skeleton for\e[0m #{pname.rubyize} \e[1mto\e[0m #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname, "main.rb")}"
    File.open(File.join(File.expand_path(Leafman::PROJECT_DIR), pname, "main.rb"), 'a') do |f|
        f.write "\nmodule #{pname.rubyize}\n#{classes.collect{|c|"\tclass #{c.rubyize}\n\t\t\n\tend\n"}.join}end\n"
    end
    puts "\e[1mchange type to\e[0m ruby"
    p['type'] = 'ruby'
    puts "\e[32m\e[1mdone!\e[0m"
end

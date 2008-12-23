Leafman::Command.new "skel-shoes", "<project-name>", "generate a Shoes skeleton for <project-name>, then set the 'type' accordingly" do |pname|
    include Leafman::Mixin
    puts "\e[1mskel-shoes:\e[0m #{pname}"
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    puts "\e[1mappend a skeleton for\e[0m #{pname.rubyize} < Shoes \e[1mto\e[0m #{p.dir("main.shoes.rb")}"
    File.open(p.dir("main.shoes.rb"), 'a') do |f|
        f.write "\nclass #{pname.rubyize} < Shoes\n\turl '/', :index\n\tdef index\n\t\tpara 'leafman rules'\n\tend\nend\n"
    end
    puts "\e[1mchange type to\e[0m shoes"
    p['type'] = 'shoes'
    puts "\e[32m\e[1mdone!\e[0m"
end

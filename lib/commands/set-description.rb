Leafman::Command.new "set-description", "<project-name>", "set the description for <project-name>" do |pname|
    include Leafman::Mixin
    p = Leafman::Projects.find pname
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    puts "\e[1mPlease type the description for #{p['name']}:\e[0m"
    p['description'] = $stdin.read
end

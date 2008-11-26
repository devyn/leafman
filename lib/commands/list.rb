Leafman::Command.new "list", "", "list of all projects" do
    include Leafman::Mixin
    puts "\e[1mproject listing\e[0m"
    Leafman::Projects.each do |p|
        puts "\e[1m*\e[0m\t#{p['name']}"
    end
end

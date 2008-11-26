Leafman::Command.new "destroy", "<project-name>", "destroy the project called <project-name>" do |pname|
    include Leafman::Mixin
    puts "\e[1mdestroy:\e[0m #{pname}"
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    FileUtils.rm_rf File.join(File.expand_path(Leafman::PROJECT_DIR), pname), :verbose => true
    puts "\e[32m\e[1mdone!\e[0m"
end
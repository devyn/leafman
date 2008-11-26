Leafman::Command.new "create", "<project-name>", "create a new project called <project-name>" do |pname|
    include Leafman::Mixin
    puts "\e[1mcreate:\e[0m #{pname}"
    FileUtils.mkdir_p File.join(File.expand_path(Leafman::PROJECT_DIR), pname), :verbose => true
    puts "\e[1mcreate project config\e[0m"
    Leafman::Projects.add(pname, 'scm' => nil, 'type' => nil)
    puts "\e[32m\e[1mdone!\e[0m"
end

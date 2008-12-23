Leafman::Command.new "darcs-init", "<project-name>", "initialize <project-name> as a Darcs repository" do |pname|
    include Leafman::Mixin
    puts "\e[1mdarcs-init:\e[0m #{pname}"
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    puts "\e[1mchdir\e[0m #{p.dir}"
    Dir.chdir(File.join(File.expand_path(Leafman::PROJECT_DIR), p.dir)) do
        puts "\e[1mdarcs initialize\e[0m"
        system('darcs', 'initialize') or (warn("\e[31mfailed to initialize.\e[0m")||true&&next)
    end
    puts "\e[1mset SCM to Darcs\e[0m"
    p['scm'] = 'darcs'
    puts "\e[32m\e[1mdone!\e[0m"
end

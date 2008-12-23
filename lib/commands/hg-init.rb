Leafman::Command.new "hg-init", "<project-name>", "initialize <project-name> as a Mercurial repository" do |pname|
    include Leafman::Mixin
    puts "\e[1mhg-init:\e[0m #{pname}"
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    puts "\e[1mchdir\e[0m #{p.dir}"
    Dir.chdir(p.dir) do
        puts "\e[1mhg init\e[0m"
        system('hg', 'init') or (warn("\e[31mfailed to initialize.\e[0m")||true&&next)
    end
    puts "\e[1mset SCM to hg\e[0m"
    p['scm'] = 'hg'
    puts "\e[32m\e[1mdone!\e[0m"
end

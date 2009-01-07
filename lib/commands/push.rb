Leafman::Command.new "push", "[project-names...]", "pushes all distributed enabled projects or [project-names...] to the server" do |*pnames|
    include Leafman::Mixin
    Leafman::Projects.each(*pnames) do |p|
        if p['scm'] and (p['scm'] != 'svn') and p['do_push']
            case p['scm']
                when 'git'
                    scm_code = "\e[32m"
                when 'svn'
                    scm_code = "\e[34m"
                when 'bzr'
                    scm_code = "\e[33m"
                when 'hg'
                    scm_code = "\e[36m"
                when 'darcs'
                    scm_code = "\e[35m"
            end
            puts "\e[1mpush:\e[0m #{scm_code}#{p['name']}\e[0m"
            scm_spec = []
            scm_spec << 'origin' if p['scm'] == 'git'
            Dir.chdir(File.join(File.expand_path(Leafman::PROJECT_DIR), p['name'])) do
                system p['scm'], 'push', *scm_spec
            end
        end
    end
    puts "\e[32m\e[1mdone!\e[0m"
end

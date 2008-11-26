Leafman::Command.new "sync", "", "syncs all enabled projects with the server" do
    include Leafman::Mixin
    Leafman::Projects.each do |p|
        if (p['scm'] == 'git' and p['fetch'])
            puts "\e[1msync-git:\e[0m #{p['name']}"
            Dir.chdir(File.join(File.expand_path(Leafman::PROJECT_DIR), p['name'])) do
                system("git", "pull", p['fetch']) or warn("\e[31m\e[1mcould not pull for\e[0m #{p['name']}")
            end
        elsif p['scm'] == 'svn'
            puts "\e[1msync-svn:\e[0m #{p['name']}"
            Dir.chdir(File.join(File.expand_path(Leafman::PROJECT_DIR), p['name'])) do
                system("svn", "up") or warn("\e[31m\e[1mcould not update\e[0m #{p['name']}")
            end
        elsif (p['scm'] == 'bzr') and p['do_update']
            puts "\e[1msync-bzr:\e[0m #{p['name']}"
            Dir.chdir(File.join(File.expand_path(Leafman::PROJECT_DIR), p['name'])) do
                system("bzr", "up") or warn("\e[31m\e[1mcould not update\e[0m #{p['name']}")
            end
        elsif (p['scm'] == 'hg') and p['do_pull']
            puts "\e[1msync-hg:\e[0m #{p['name']}"
            Dir.chdir(File.join(File.expand_path(Leafman::PROJECT_DIR), p['name'])) do
                system("hg", "pull") or warn("\e[31m\e[1mcould not pull for\e[0m #{p['name']}")
            end
        else
            next
        end
    end
    puts "\e[32m\e[1mdone!\e[0m"
end

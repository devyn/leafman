Leafman::Command.new "sync", "[project-names...]", "syncs all enabled projects or [project-names...] with the server" do |*pnames|
    include Leafman::Mixin
    Leafman::Projects.each(*pnames) do |p|
        if (p['scm'] == 'git') and p['fetch']
            puts "\e[1msync:\e[0m \e[32m#{p['name']}\e[0m"
            Dir.chdir(p.dir) do
                system("git", "pull", p['fetch']) or warn("\e[31m\e[1mcould not pull for\e[0m \e[32m#{p['name']}\e[0m")
            end
        elsif (p['scm'] == 'svn') and p['do_update']
            puts "\e[1msync:\e[0m \e[34m#{p['name']}\e[0m"
            Dir.chdir(p.dir) do
                system("svn", "up") or warn("\e[31m\e[1mcould not update\e[0m \e[32m#{p['name']}\e[0m")
            end
        elsif (p['scm'] == 'bzr') and p['do_update']
            puts "\e[1msync:\e[0m \e[33m#{p['name']}\e[0m"
            Dir.chdir(p.dir) do
                system("bzr", "up") or warn("\e[31m\e[1mcould not update\e[0m \e[33m#{p['name']}\e[0m")
            end
        elsif (p['scm'] == 'hg') and p['do_pull']
            puts "\e[1msync:\e[0m \e[36m#{p['name']}\e[0m"
            Dir.chdir(p.dir) do
                system("hg", "pull") or warn("\e[31m\e[1mcould not pull for\e[0m \e[36m#{p['name']}\e[0m")
            end
        elsif (p['scm'] == 'darcs') and p['do_pull']
            puts "\e[1msync:\e[0m \e[35m#{p['name']}\e[0m"
            Dir.chdir(p.dir) do
                system("darcs", "pull") or warn("\e[31m\e[1mcould not pull for\e[0m \e[35m#{p['name']}\e[0m")
            end
        elsif p['synkage_url']
            puts "\e[1msync:\e[0m #{p['name']}\e[0m"
            require 'lib/synkage'
            sy = Synkage.new(p['synkage_url'], p.dir)
            puts "fetching a list of all files on server..."
            ws = sy.fetch_whats - ['.leafman-project']
            puts "making the folder structure..."
            sy.expand_dir_for *ws
            puts "searching for changes..."
            wc = 0
            ws.each do |w|
                unless sy.up_to_date?(w)
                    puts "fetching #{w}"
                    sy.download w
                    wc += 1
                end
            end
            puts "#{wc} files changed."
        else
            next
        end
    end
    puts "\e[32m\e[1mdone!\e[0m"
end

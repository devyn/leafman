require 'lib/synkage'
Leafman::Command.new "sync", "[project-names...]", "syncs all enabled projects or [project-names...] with the server" do |*pnames|
    include Leafman::Mixin
    title "syncing projects"
    Leafman::Projects.each(*pnames) do |p|
        if (p['scm'] == 'git') and p['fetch']
            task "sync: \e[32m#{p['name']}\e[0m"
            Dir.chdir(p.dir) do
                system("git", "pull", p['fetch'], "master") or error("could not pull for #{p['name']}")
            end
        elsif (p['scm'] == 'svn') and p['do_update']
            task "sync: \e[34m#{p['name']}\e[0m"
            Dir.chdir(p.dir) do
                system("svn", "up") or error("could not update #{p['name']}")
            end
        elsif (p['scm'] == 'bzr') and p['do_update']
            task "sync: \e[33m#{p['name']}\e[0m"
            Dir.chdir(p.dir) do
                system("bzr", "up") or error("could not update #{p['name']}")
            end
        elsif (p['scm'] == 'hg') and p['do_pull']
            task "sync: \e[36m#{p['name']}\e[0m"
            Dir.chdir(p.dir) do
                system("hg", "pull") and system("hg", "update") or error("could not pull for #{p['name']}")
            end
        elsif (p['scm'] == 'darcs') and p['do_pull']
            task "sync: \e[35m#{p['name']}\e[0m"
            Dir.chdir(p.dir) do
                system("darcs", "pull", '-a') or error("could not pull for #{p['name']}")
            end
        elsif p['synkage_url']
            task "sync: \e[0m#{p['name']}"
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
    finished
end

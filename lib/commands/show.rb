Leafman::Command.new "show", "<project-name>", "show everything known about the project called <project-name>" do |pname|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    puts "\e[1m#{p['name']}\e[0m"
    case p['scm']
    when 'git'
        puts "...\tuses \e[32m\e[1mGit\e[0m#{", pushes" if p['do_push']}#{", syncs with \e[36m#{p['fetch']}\e[0m" if p['fetch']}."
        Dir.chdir(p.dir) { puts "...\tat revision \e[1m\e[33m#{`git rev-parse --short HEAD`.chomp}\e[0m." } if Leafman.config['show_revision']
    when 'svn'
        puts "...\tuses \e[34m\e[1mSubversion\e[0m#{", syncs" if p['do_update']}."
        Dir.chdir(p.dir) { puts "...\tat revision \e[1m\e[33m#{`svnversion`.chomp}\e[0m." } if Leafman.config['show_revision']
    when 'bzr'
        puts "...\tuses \e[33m\e[1mBazaar\e[0m#{", pushes" if p['do_push']}#{", syncs" if p['do_update']}."
        Dir.chdir(p.dir) { puts "...\tat revision \e[1m\e[33m#{`bzr log -r -1`.scan(/^revno: (\d+)$/).flatten.first}\e[0m." } if Leafman.config['show_revision']
    when 'hg'
        puts "...\tuses \e[36m\e[1mMercurial\e[0m#{", pushes" if p['do_push']}#{", syncs" if p['do_pull']}."
        Dir.chdir(p.dir) { puts "...\tat revision \e[1m\e[33m#{`hg identify`.chomp}\e[0m." } if Leafman.config['show_revision']
    when 'darcs'
        puts "...\tuses \e[35m\e[1mDarcs\e[0m#{", pushes" if p['do_push']}#{", syncs" if p['do_pull']}."
        # HELP! I need Darcs revision detecting code!
    else
        puts "...\tdoesn't have \e[1mversion control\e[0m."
    end
    puts "...\tis a \e[1m#{p['type'].capitalize}\e[0m project." if p['type']
    p['bugs'].each_with_index do |b, i|
        puts "...\t\e[1m\e[31mbug (\e[36mb#{i}\e[31m):\e[0m #{b}"
    end if p['bugs']
    p['todos'].each_with_index do |t, i|
        puts "...\t\e[1m\e[33mtask (\e[36mt#{i}\e[33m):\e[0m #{t}"
    end if p['todos']
end

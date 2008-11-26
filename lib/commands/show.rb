Leafman::Command.new "show", "<project-name>", "show everything known about the project called <project-name>" do |pname|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    puts "\e[1m#{p['name']}\e[0m"
    puts "...\tuses \e[32m\e[1mGit\e[0m#{" and fetches from \e[36m#{p['fetch']}\e[0m" if p['fetch']}." if p['scm'] == 'git'
    puts "...\tuses \e[34m\e[1mSubversion\e[0m." if p['scm'] == 'svn'
    puts "...\tuses \e[33m\e[1mBazaar\e[0m#{" and runs updates" if p['do_update']}." if p['scm'] == 'bzr'
    puts "...\tuses \e[36m\e[1mMercurial\e[0m#{" and pulls" if p['do_pull']}." if p['scm'] == 'hg'
    puts "...\tdoesn't have \e[1mversion control\e[0m." unless p['scm']
    puts "...\tis a \e[1m#{p['type'].capitalize}\e[0m project." if p['type']
    p['bugs'].each_with_index do |b, i|
        puts "...\t\e[1m\e[31mbug (\e[36mb#{i}\e[31m):\e[0m #{b}"
    end if p['bugs']
    p['todos'].each_with_index do |t, i|
        puts "...\t\e[1m\e[33mtask (\e[36mt#{i}\e[33m):\e[0m #{t}"
    end if p['todos']
end
Leafman::Command.new "show", "<project-name>", "show everything known about the project called <project-name>" do |pname|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    title p['name']
    if d = p['description']
        print "\e[33m"
        puts d.split("\n").collect{|l|"   \t#{l}"}.join("\n")
        puts "\e[0m"
    end
    case p['scm']
    when 'git'
        list_item "uses \e[32mGit\e[0m#{", pushes" if p['do_push']}#{", syncs with #{p['fetch']}" if p['fetch']}.", '...'
        Dir.chdir(p.dir) { list_item "at revision #{`git rev-parse --short HEAD`.chomp}.", '...' } if Leafman.config['show_revision']
    when 'svn'
        list_item "uses \e[34mSubversion\e[0m#{", syncs" if p['do_update']}.", '...'
        Dir.chdir(p.dir) { list_item "at revision #{`svnversion`.chomp}.", '...' } if Leafman.config['show_revision']
    when 'bzr'
        list_item "uses \e[33mBazaar\e[0m#{", pushes" if p['do_push']}#{", syncs" if p['do_update']}.", '...'
        Dir.chdir(p.dir) { list_item "at revision #{`bzr log -r -1`.scan(/^revno: (\d+)$/).flatten.first}.", '...' } if Leafman.config['show_revision']
    when 'hg'
        list_item "uses \e[36mMercurial\e[0m#{", pushes" if p['do_push']}#{", syncs" if p['do_pull']}.", '...'
        Dir.chdir(p.dir) { list_item "at revision #{`hg identify`.chomp}.", '...' } if Leafman.config['show_revision']
    when 'darcs'
        list_item "uses \e[35mDarcs\e[0m#{", pushes" if p['do_push']}#{", syncs" if p['do_pull']}.", '...'
        # HELP! I need Darcs revision detecting code!
    else
        list_item "doesn't have version control#{", syncs" if p['synkage_url']}.", '...'
    end
    list_item "is a #{p['type'].capitalize} project.", '...' if p['type']
    p['bugs'].each_with_index do |b, i|
        list_item "bug  (\e[31mb#{i}\e[0m): #{b}", '...'
    end if p['bugs']
    p['todos'].each_with_index do |t, i|
        list_item "task (\e[33mt#{i}\e[0m): #{t}", '...'
    end if p['todos']
end

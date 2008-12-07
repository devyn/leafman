Leafman::Command.new "set-sync", "<project-name> on|off|<git-remote>|<synkage-url>", "choose whether <project-name> is sync-enabled or not. for Git projects you may choose a remote (defaults to origin), and for other projects you must specify a Synkage base url or 'off'", "configuration" do |pname, opt|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    case p['scm']
    when 'git'
        if opt =~ /^on$/i
            p['fetch'] = 'origin'
        elsif opt =~ /^off$/i
            p['fetch'] = nil
        else
            p['fetch'] = opt
        end
    when 'bzr', 'svn'
        p['do_update'] = opt =~ /^on$/i ? true : false
    when 'hg', 'darcs'
        p['do_pull'] = opt =~ /^on$/i ? true : false
    else
        if opt =~ /^off$/i
            p['synkage_url'] = nil
        else
            p['synkage_url'] = opt
        end
    end
end

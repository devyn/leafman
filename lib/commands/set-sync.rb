Leafman::Command.new "set-sync", "<project-name> on|off|<git-remote>", "choose whether <project-name> is sync-enabled or not. for Git projects you may choose a remote (defaults to origin)" do |pname, opt|
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
        warn("\e[31m\e[1mproject does not use a valid SCM.\e[0m")||true&&next
    end
end

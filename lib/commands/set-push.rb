Leafman::Command.new "set-push", "<project-name> on|off", "choose whether <project-name> is push-enabled or not", "configuration" do |pname, opt|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    warn("\e[31m\e[1mproject does not use a valid SCM.\e[0m")||true&&next unless p['scm']
    warn("\e[31m\e[1mproject uses a non-distibuted SCM.\e[0m")||true&&next if p['scm'] == 'svn'
    p['do_push'] = opt =~ /^on$/i ? true : false
end

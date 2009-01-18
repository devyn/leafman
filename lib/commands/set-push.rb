Leafman::Command.new "set-push", "<project-name> on|off", "choose whether <project-name> is push-enabled or not", "configuration" do |pname, opt|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    error("project does not use a valid SCM.")||true&&next unless p['scm']
    error("project uses a non-distibuted SCM.")||true&&next if p['scm'] == 'svn'
    p['do_push'] = opt =~ /^on$/i ? true : false
end

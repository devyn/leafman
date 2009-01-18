require 'net/http'
require 'open-uri'
require 'lib/synkage'
Leafman::Command.new "clone", "<project-name> [host[:port]]", "clones a project from the leafman web interface into your database" do |pname, *a|
    include Leafman::Mixin
    begin
        as = (a[0] or 'localhost').split(':')
        title "clone: #{pname} at: #{a[0] or 'localhost'}"
        task "fetching project SCM"
        case open(Synkage.escape("http://localhost:8585/#{pname}.project")).read.scan(/class='scm-(\w+)'/).flatten.first
        when 'git'
            command "git clone"
            system "git", "clone", Synkage.escape("http://#{as[0]}:#{as[1] or 8585}/#{pname}.project/files/.git/"), File.join(File.expand_path(Leafman::PROJECT_DIR), pname)
        when 'svn'
            error "Sorry, no Subversion support."
            next
        when 'bzr'
            command "bzr checkout"
            system "bzr", "co", Synkage.escape("http://#{as[0]}:#{as[1] or 8585}/#{pname}.project/files/"), File.join(File.expand_path(Leafman::PROJECT_DIR), pname)
        when 'hg'
            error "Sorry, no Mercurial support. (yet!)"
            next
        when 'darcs'
            command "darcs get --lazy"
            system "darcs", "get", "--lazy", Synkage.escape("http://#{as[0]}:#{as[1] or 8585}/#{pname}.project/files/.git/"), File.join(File.expand_path(Leafman::PROJECT_DIR), pname)
        else
            sy = Synkage.new("http://#{as[0]}:#{as[1] or 8585}/#{pname}.project/files/", File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
            task "fetching a list of all files on server"
            ws = sy.fetch_whats
            task "making the folder structure"
            sy.expand_dir_for *ws
            task "beginning file download"
            ws.each do |w|
                unless sy.up_to_date?(w)
                    command "fetching #{w}"
                    sy.download w
                end
            end
        end
        task "create project config"
        Leafman::Projects.add(pname, {})
        task "detect project information"
        Leafman::Projects.find(pname).detect
        finished
    rescue Exception # anything
        if $DEBUG
            raise $!
        else
            error($!.message)||true&&next
        end
    end
end

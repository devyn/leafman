require 'net/http'
require 'open-uri'
require 'lib/synkage'
Leafman::Command.new "clone", "<project-name> [host[:port]]", "clones a project from the leafman web interface into your database" do |pname, *a|
    include Leafman::Mixin
    begin
        as = (a[0] or 'localhost').split(':')
        puts "\e[1mclone:\e[0m #{pname} \e[1mat:\e[0m #{a[0] or 'localhost'}"
        puts "\e[1mfetching project SCM\e[0m"
        case open(Synkage.escape("http://localhost:8585/#{pname}.project")).read.scan(/class='scm-(\w+)'/).flatten.first
        when 'git'
            puts "\e[1mgit clone\e[0m"
            system "git", "clone", Synkage.escape("http://#{as[0]}:#{as[1] or 8585}/#{pname}.project/files/.git/"), File.join(File.expand_path(Leafman::PROJECT_DIR), pname)
        when 'svn'
            warn "\e[31mSorry, no Subversion support.\e[0m"
            next
        when 'bzr'
            puts "\e[1mbzr checkout\e[0m"
            system "bzr", "co", Synkage.escape("http://#{as[0]}:#{as[1] or 8585}/#{pname}.project/files/"), File.join(File.expand_path(Leafman::PROJECT_DIR), pname)
        when 'hg'
            warn "\e[31mSorry, no Mercurial support. (yet!)\e[0m"
            next
        when 'darcs'
            puts "\e[1mdarcs get --lazy\e[0m"
            system "darcs", "get", "--lazy", Synkage.escape("http://#{as[0]}:#{as[1] or 8585}/#{pname}.project/files/.git/"), File.join(File.expand_path(Leafman::PROJECT_DIR), pname)
        else
            sy = Synkage.new("http://#{as[0]}:#{as[1] or 8585}/#{pname}.project/files/", File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
            puts "\e[1mfetching a list of all files on server...\e[0m"
            ws = sy.fetch_whats
            puts "\e[1mmaking the folder structure...\e[0m"
            sy.expand_dir_for *ws
            puts "\e[1mbeginning file download...\e[0m"
            ws.each do |w|
                unless sy.up_to_date?(w)
                    puts "\e[1mfetching\e[0m #{w}"
                    sy.download w
                end
            end
        end
        puts "\e[1mcreate project config\e[0m"
        Leafman::Projects.add(pname, {})
        puts "\e[1mdetect project information\e[0m"
        Leafman::Projects.find(pname).detect
        puts "\e[1m\e[32mdone!\e[0m"
    rescue Exception # anything
        if $DEBUG
            raise $!
        else
            warn("\e[1m\e[31mERROR:\e[0m\e[31m #{$!.message}\e[0m")||true&&next
        end
    end
end

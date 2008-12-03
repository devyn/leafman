# Leafman's clone architecture (works with web interface)
# needs Hpricot
# usually invoked with:
#     $ ruby leafman.rb clone <project-name> [host[:port]]
require 'net/http'
require 'hpricot'
require 'uri'
require 'open-uri'
require 'cgi'
require 'fileutils'
module Leafman
    module Cloneable; extend self
        def clone_info(project_name, host='localhost', port=8585)
            project_page = Hpricot(open("http://#{host}:#{port}/#{CGI.escape(project_name)}.project/").read) rescue(return({:error => "404 - Project not found"}))
            if project_page.at(".scm-git")
                return({:scm => 'git', :run => ['git', 'clone', "http://#{host}:#{port}/#{CGI.escape(project_name)}.project/files/.git/", File.join(File.expand_path(Leafman::PROJECT_DIR), project_name)]})
            elsif project_page.at(".scm-svn")
                return({:scm => 'svn', :error => "No clone support for Subversion"})
            elsif project_page.at(".scm-bzr")
                return({:scm => 'bzr', :run => ['bzr', 'co', "http://#{host}:#{port}/#{CGI.escape(project_name)}.project/files/", File.join(File.expand_path(Leafman::PROJECT_DIR), project_name)]})
            elsif project_page.at(".scm-hg")
                return({:scm => 'hg', :error => "No clone support for Mercurial (yet!)"})
            elsif project_page.at(".scm-darcs")
                return({:scm => 'darcs', :run => ['darcs', 'get', '--lazy', "http://#{host}:#{port}/#{CGI.escape(project_name)}.project/files/", File.join(File.expand_path(Leafman::PROJECT_DIR), project_name)]})
            else
                files = {}
                # follow all links
                follower = proc do |url, into|
                    dir_page = Hpricot(open(url).read)
                    dir_page.search(".indir").each do |elem|
                        follower.call("http://#{host}:#{port}"+elem[:href], File.join(into, elem.innerText))
                    end
                    dir_page.search(".infile").each do |elem|
                        files["http://#{host}:#{port}"+elem[:href]] = File.join(into, elem.innerText)
                    end
                end
                follower.call("http://#{host}:#{port}/#{CGI.escape(project_name)}.project/files/", File.join(File.expand_path(Leafman::PROJECT_DIR), project_name))
                return({:download => files})
            end
        end
        def prepare_clone(files, verbose=false) # files = clone_info(...)[:download]
            # create the directories to be downloaded into
            files.each do |src, dest|
                FileUtils.mkdir_p File.dirname(dest), :verbose => verbose
            end
        end
        def download(src, dest)
            uri = URI.parse(src)
            f = File.open(dest, 'w')
            Net::HTTP.start(uri.host, uri.port) do |http|
                Leafman.print "\e[1mdownloading\e[0m #{src} "
                http.request_get(uri.path){|res| res.read_body {|seg|print '.'; f.write seg } }
                puts 'done!'
            end
            f.close
        end
        def auto_clone(*args)
            Leafman.print "\e[1mgetting project information...\e[0m"
            ci = clone_info(*args)
            r= nil
            puts 'done!'
            if ci[:error]
                Leafman.puts "\e[1m\e[31mERROR:\e[0m\e[31m #{ci[:error]}\e[0m"
                return false
            elsif ci[:run]
                puts ci[:run].join(' ')
                r= system(*ci[:run])
            elsif ci[:download]
                Leafman.print "\e[1mpreparing to clone...\e[0m"
                prepare_clone ci[:download]
                puts 'done!'
                ci[:download].each do |src,dest|
                    download src, dest
                end
                r= true
            end
            Leafman.print "\e[1madding to database...\e[0m"
            Leafman::Projects.add(args.first, 'scm' => ci[:scm])
            puts 'done!'
        end
    end
end

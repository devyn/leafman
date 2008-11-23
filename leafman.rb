#!/usr/bin/env ruby
# Leafman: The GREEN MEAN Managing MACHINE!

require 'yaml'
require 'fileutils'
class String
    def rubyize
        gsub(/\/(.?)/) { "::#{$1.upcase}" }.gsub(/(?:^|_|-)(.)/) { $1.upcase } # borrowed from ActiveSupport
    end
end
module Leafman; extend self
    PROJECT_DIR = "~/Projects"
    def puts(*s)
        if (@ldb['config']['colors'] rescue nil)
            Kernel.puts *s
        else
            Kernel.puts *(s.collect{|s|s.gsub(/\e\[\d+m/, '')})
        end
    end
    def warn(*s)
        if (@ldb['config']['colors'] rescue nil)
            Kernel.warn *s
        else
            Kernel.warn *(s.collect{|s|s.gsub(/\e\[\d+m/, '')})
        end
    end
    def load_ldb
        @ldb = YAML.load(File.read(File.join(File.expand_path(PROJECT_DIR), ".leafman")))
    end
    def save_ldb
        File.open(File.join(File.expand_path(PROJECT_DIR), ".leafman"), "w") {|f| f.write YAML.dump(@ldb)}
    end
    def parse_args(*argv)
        load_ldb rescue warn("\e[33mCould not load the Leafman database. Ignore this if you are running an INIT.\e[0m")
        case argv.shift
            when /^init$/i
                init *argv
            when /^create$/i
                create *argv
            when /^destroy$/i
                destroy *argv
            when /^list$/i
                list *argv
            when /^show$/i
                show *argv
            when /^fork$/i
                git_fork *argv
            when /^sync$/i
                sync_all *argv
            when /^svn-get$/i
                svn_get *argv
            when /^git-init$/i
                git_init *argv
            when /^skel-ruby$/i
                skel_ruby *argv
            when /^skel-shoes$/i
                skel_shoes *argv
            when /^colors$/i
                @ldb['config']['colors'] = (argv.first =~ /^on$/i)
            when /^help$/i, nil
                puts "\e[1m\e[36mL \e[32mE \e[33mA \e[36mF \e[32mM \e[33mA \e[36mN\e[0m, The GREEN MEAN Managing MACHINE!"
                puts "\e[1m\e[34mUsage:\e[0m #{$0} <command> [parameters...]"
                puts
                puts "\e[1m\e[34mCommand List:\e[0m"
                puts "\e[1minit\e[0m \e[33m# initialize the project directories for first time\e[0m"
                puts "\e[1mcreate\e[0m <project-name> \e[33m# create a new project called <project-name>\e[0m"
                puts "\e[1mdestroy\e[0m <project-name> \e[33m# destroy the project called <project-name>\e[0m"
                puts "\e[1mlist\e[0m \e[33m# list of all projects\e[0m"
                puts "\e[1mshow\e[0m <project-name> \e[33m# show everything known about the project called <project-name>\e[0m"
                puts "\e[1mfork\e[0m <project-name> <git-url> \e[33m# fork the GIT project called <project-name> at <git-url>\e[0m"
                puts "\e[1msync\e[0m \e[33m# synchronize all GIT and SVN projects with the server\e[0m"
                puts "\e[1msvn-get\e[0m <project-name> <svn-url> \e[33m# checkout the SVN project called <project-name at <svn-url>\e[0m"
                puts "\e[1mgit-init\e[0m <project-name> \e[33m# setup the project called <project-name> for GIT\e[0m"
                puts "\e[1mskel-ruby\e[0m <project-name> [classes...] \e[33m# make a ruby skeleton for <project-name> and change the type to 'ruby'\e[0m"
                puts "\e[1mskel-shoes\e[0m <project-name> \e[33m# make a shoes skeleton for <project-name> and change the type to 'shoes'\e[0m"
                puts
                puts "\e[1m\e[34mConfig Commands:\e[0m"
                puts "\e[1mcolors\e[0m on|off \e[33m# turn ANSI escape sequences on or off\e[0m"
                puts
                puts "\e[1m\e[34mCreated by ~devyn\e[0m"
            else
                warn "\e[31m\e[1mInvalid command.\e[0m"
        end
        save_ldb
    end
    def init
        epath = File.expand_path PROJECT_DIR
        puts "\e[1minit:\e[0m #{epath}"
        FileUtils.mkdir_p epath, :verbose => true
        puts "\e[1mdatabase skeleton\e[0m"
        @ldb = {'config' => {}, 'projects' => []}
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def create(pname)
        puts "\e[1mcreate:\e[0m #{pname}"
        FileUtils.mkdir_p File.join(File.expand_path(PROJECT_DIR), pname), :verbose => true
        puts "\e[1madd\e[0m #{pname} \e[1mto database\e[0m"
        @ldb['projects'] << {'name' => pname, 'type' => nil, 'scm' => nil}
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def destroy(pname)
        puts "\e[1mdestroy:\e[0m #{pname}"
        FileUtils.rm_rf File.join(File.expand_path(PROJECT_DIR), pname), :verbose => true
        puts "\e[1mremove\e[0m #{pname} \e[1mfrom database\e[0m"
        @ldb['projects'].delete @ldb['projects'].select{|p|p['name']==pname}.first
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def list
        puts "\e[1mProject Listing\e[0m"
        @ldb['projects'].each do |p|
            puts "\e[1m*\e[0m\t#{p['name']}"
        end
        return true
    end
    def show(pname)
        @ldb['projects'].select{|p|p['name'] == pname}.first.each do |k,v|
            puts "\e[1m#{k}\e[0m\t\t= #{v.inspect}"
        end
        return true
    end
    def git_fork(pname, git_url)
        puts "\e[1mfork:\e[0m #{pname} \e[1mfrom:\e[0m #{git_url}"
        puts "\e[1mClone\e[0m #{git_url} \e[1minto\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname)}"
        return warn("\e[31m\e[1mgit clone failed.\e[0m") unless system("git", "clone", "-o", "forked_from", git_url, File.join(File.expand_path(PROJECT_DIR), pname))
        puts "\e[1madd\e[0m #{pname} \e[1mto database as GIT repository, fetching from remote '\e[0mforked_from\e[1m'\e[0m"
        @ldb['projects'] << {'name' => pname, 'type' => nil, 'scm' => 'git', 'fetch' => 'forked_from'}
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def sync_all
        puts "\e[1mSyncing all GIT repositories...\e[0m"
        @ldb['projects'].select{|p|p['scm']=='git' and p['fetch']}.each do |p|
            puts "\e[1msync:\e[0m #{p['name']}"
            Dir.chdir(File.join(File.expand_path(PROJECT_DIR), p['name'])) do
                system("git", "pull", p['fetch']) or warn("\e[31m\e[1mcould not pull for\e[0m #{p['name']}")
            end
        end
        puts "\e[1mSyncing all SVN repositories...\e[0m"
        @ldb['projects'].select{|p|p['scm']=='svn'}.each do |p|
            puts "\e[1msync:\e[0m #{p['name']}"
            Dir.chdir(File.join(File.expand_path(PROJECT_DIR), p['name'])) do
                system("svn", "up") or warn("\e[31m\e[1mcould not update\e[0m #{p['name']}")
            end
        end
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def svn_get(pname, svn_url)
        puts "\e[1msvn-get:\e[0m #{pname} \e[1mfrom:\e[0m #{svn_url}"
        puts "\e[1mCheckout\e[0m #{svn_url} \e[1minto\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname)}"
        return warn("\e[31m\e[1msvn checkout failed.\e[0m") unless system("svn", "checkout", svn_url, File.join(File.expand_path(PROJECT_DIR), pname))
        puts "\e[1madd\e[0m #{pname} \e[1mto database as SVN repository\e[0m"
        @ldb['projects'] << {'name' => pname, 'type' => nil, 'scm' => 'svn'}
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def git_init(pname)
        puts "\e[1mgit-init:\e[0m #{pname}"
        puts "\e[1mchdir\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname)}"
        Dir.chdir(File.join(File.expand_path(PROJECT_DIR), pname)) do
            puts "\e[1mgit init\e[0m"
            system('git', 'init') or return(warn("\e[31mFailed to initialize.\e[0m"))
        end
        puts "\e[1mset\e[0m \"#{pname}\".scm \e[1mto GIT\e[0m"
        @ldb['projects'].select{|p|p['name']==pname}.first['scm'] = 'git'
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def skel_ruby(pname, *classes)
        puts "\e[1mskel-ruby:\e[0m #{pname}"
        puts "\e[1mappend a skeleton for\e[0m #{pname.rubyize} \e[1mto\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname, "main.rb")}"
        File.open(File.join(File.expand_path(PROJECT_DIR), pname, "main.rb"), 'a') do |f|
            f.write "\nmodule #{pname.rubyize}\n#{classes.collect{|c|"\tclass #{c.rubyize}\n\t\t\n\tend\n"}.join}end\n"
        end
        puts "\e[1mchange type to\e[0m ruby"
        @ldb['projects'].select{|p|p['name']==pname}.first['type'] = 'ruby'
        puts "\e[32m\e[1mdone!\e[0m"
    end
    def skel_shoes(pname)
        puts "\e[1mskel-shoes:\e[0m #{pname}"
        puts "\e[1mappend a skeleton for\e[0m #{pname.rubyize} < Shoes \e[1mto\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname, "main.shoes.rb")}"
        File.open(File.join(File.expand_path(PROJECT_DIR), pname, "main.shoes.rb"), 'a') do |f|
            f.write "\nclass #{pname.rubyize} < Shoes\n\turl '/', :index\n\tdef index\n\t\tpara 'leafman rules'\n\tend\nend\n"
        end
        puts "\e[1mchange type to\e[0m shoes"
        @ldb['projects'].select{|p|p['name']==pname}.first['type'] = 'shoes'
        puts "\e[32m\e[1mdone!\e[0m"
    end
end
if __FILE__ == $0
    Leafman.parse_args *ARGV.dup
end


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
    PROJECT_DIR = ENV['LEAFMAN_PATH'] || "~/Projects"
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
    def abort(*s)
        warn *s
        exit 1
    end
    def load_ldb
        @ldb = YAML.load(File.read(File.join(File.expand_path(PROJECT_DIR), ".leafman")))
    end
    def save_ldb
        File.open(File.join(File.expand_path(PROJECT_DIR), ".leafman"), "w") {|f| f.write YAML.dump(@ldb)}
    end
    def parse_args(*argv)
        load_ldb rescue warn("\e[33mcould not load the Leafman database. ignore this if you are running an 'init'.\e[0m")
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
            when /^git-get$/i
                git_get *argv
            when /^bzr-get$/i
                bzr_get *argv
            when /^hg-get$/i
                hg_get *argv
            when /^git-init$/i
                git_init *argv
            when /^bzr-init$/i
                bzr_init *argv
            when /^hg-init$/i
                hg_init *argv
            when /^skel-ruby$/i
                skel_ruby *argv
            when /^skel-shoes$/i
                skel_shoes *argv
            when /^skel-rails$/i
                skel_rails *argv
            when /^import$/i
                proj_import *argv
            when /^import-git$/i
                proj_import_git *argv
            when /^import-svn$/i
                proj_import_svn *argv
            when /^import-bzr$/i
                proj_import_bzr *argv
            when /^import-hg$/i
                proj_import_hg *argv
            when /^colors$/i
                @ldb['config']['colors'] = (argv.first =~ /^on$/i)
            when /^help$/i, nil
                puts "\e[1m\e[36mL \e[32mE \e[33mA \e[36mF \e[32mM \e[33mA \e[36mN\e[0m, The GREEN MEAN Managing MACHINE!"
                puts "\e[1m\e[34musage:\e[0m #{$0} <command> [parameters...]"
                puts
                puts "\e[1m\e[34mcommand list:\e[0m"
                puts "\e[1minit\e[0m \e[33m# initialize the project directories for first time\e[0m"
                puts "\e[1mcreate\e[0m <project-name> \e[33m# create a new project called <project-name>\e[0m"
                puts "\e[1mdestroy\e[0m <project-name> \e[33m# destroy the project called <project-name>\e[0m"
                puts "\e[1mlist\e[0m \e[33m# list of all projects\e[0m"
                puts "\e[1mshow\e[0m <project-name> \e[33m# show everything known about the project called <project-name>\e[0m"
                puts "\e[1mfork\e[0m <project-name> <git-url> \e[33m# fork the Git project called <project-name> at <git-url>\e[0m"
                puts "\e[1msync\e[0m \e[33m# synchronize all GIT and SVN projects with the server\e[0m"
                puts "\e[1msvn-get\e[0m <project-name> <svn-url> \e[33m# checkout the Subversion project called <project-name> at <svn-url>\e[0m"
                puts "\e[1mgit-get\e[0m <project-name> <git-url> \e[33m# clone the Git project called <project-name> at <git-url>\e[0m"
                puts "\e[1mbzr-get\e[0m <project-name> <bzr-url> \e[33m# checkout the Bazaar project called <project-name> at <bzr-url>\e[0m"
                puts "\e[1mhg-get\e[0m <project-name> <hg-url> \e[33m# clone the Mercurial project called <project-name> at <hg-url>\e[0m"
                puts "\e[1mgit-init\e[0m <project-name> \e[33m# setup the project called <project-name> for Git\e[0m"
                puts "\e[1mbzr-init\e[0m <project-name> \e[33m# setup the project called <project-name> for Bazaar\e[0m"
                puts "\e[1mhg-init\e[0m <project-name> \e[33m# setup the project called <project-name> for Mercurial\e[0m"
                puts "\e[1mskel-ruby\e[0m <project-name> [classes...] \e[33m# make a ruby skeleton for <project-name> and change the type to 'ruby'\e[0m"
                puts "\e[1mskel-shoes\e[0m <project-name> \e[33m# make a shoes skeleton for <project-name> and change the type to 'shoes'\e[0m"
                puts "\e[1mskel-rails\e[0m <project-name> [rails-command-opts...] \e[33m# make a ruby on rails skeleton for <project-name> and change the type to 'rails'\e[0m"
                puts "\e[1mimport\e[0m <directory> \e[33m# import a project from elsewhere on the filesystem\e[0m"
                puts "\e[1mimport-git\e[0m <directory> \e[33m# import a Git project from elsewhere on the filesystem\e[0m"
                puts "\e[1mimport-svn\e[0m <directory> \e[33m# import a Subversion project from elsewhere on the filesystem\e[0m"
                puts "\e[1mimport-bzr\e[0m <directory> \e[33m# import a Bazaar project from elsewhere on the filesystem\e[0m"
                puts "\e[1mimport-hg\e[0m <directory> \e[33m# import a Mercurial project from elsewhere on the filesystem\e[0m"
                puts
                puts "\e[1m\e[34mconfig commands:\e[0m"
                puts "\e[1mcolors\e[0m on|off \e[33m# turn ANSI escape sequences on or off\e[0m"
                puts
                puts "\e[1m\e[34mcreated by ~devyn\e[0m"
            else
                warn "\e[31m\e[1minvalid command.\e[0m"
        end
        save_ldb
    end
    def init
        epath = File.expand_path PROJECT_DIR
        puts "\e[1minit:\e[0m #{epath}"
        abort("#{File.join(epath, '.leafman')}: \e[31m\e[1mfile already exists. refusing to init.\e[0m") if File.exists?(File.join(epath, '.leafman'))
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
        p = @ldb['projects'].select{|p|p['name'] == pname}.first
        return(warn("\e[31m\e[1mproject not found.\e[0m")) unless p
        FileUtils.rm_rf File.join(File.expand_path(PROJECT_DIR), pname), :verbose => true
        puts "\e[1mremove\e[0m #{pname} \e[1mfrom database\e[0m"
        @ldb['projects'].delete p
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def list
        puts "\e[1mproject listing\e[0m"
        @ldb['projects'].each do |p|
            puts "\e[1m*\e[0m\t#{p['name']}"
        end
        return true
    end
    def show(pname)
        p = @ldb['projects'].select{|p|p['name'] == pname}.first
        return(warn("\e[31m\e[1mproject not found.\e[0m")) unless p
        puts "\e[1m#{p['name']}\e[0m"
        puts "...\tuses \e[32m\e[1mGit\e[0m#{" and fetches from \e[36m#{p['fetch']}\e[0m" if p['fetch']}." if p['scm'] == 'git'
        puts "...\tuses \e[34m\e[1mSubversion\e[0m." if p['scm'] == 'svn'
        puts "...\tuses \e[33m\e[1mBazaar\e[0m#{" and runs updates" if p['do_update']}." if p['scm'] == 'bzr'
        puts "...\tuses \e[36m\e[1mMercurial\e[0m#{" and pulls" if p['do_pull']}." if p['scm'] == 'hg'
        puts "...\tdoesn't have \e[1mversion control\e[0m." unless p['scm']
        puts "...\tis a \e[1m#{p['type'].capitalize}\e[0m project." if p['type']
        return true
    end
    def git_fork(pname, git_url)
        puts "\e[1mfork:\e[0m #{pname} \e[1mfrom:\e[0m #{git_url}"
        puts "\e[1mclone\e[0m #{git_url} \e[1minto\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname)}"
        return warn("\e[31m\e[1mgit clone failed.\e[0m") unless system("git", "clone", "-o", "forked_from", git_url, File.join(File.expand_path(PROJECT_DIR), pname))
        puts "\e[1madd\e[0m #{pname} \e[1mto database as GIT repository, fetching from remote '\e[0mforked_from\e[1m'\e[0m"
        @ldb['projects'] << {'name' => pname, 'type' => nil, 'scm' => 'git', 'fetch' => 'forked_from'}
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def sync_all
        puts "\e[1msyncing all Git repositories...\e[0m"
        @ldb['projects'].select{|p|p['scm']=='git' and p['fetch']}.each do |p|
            puts "\e[1msync:\e[0m #{p['name']}"
            Dir.chdir(File.join(File.expand_path(PROJECT_DIR), p['name'])) do
                system("git", "pull", p['fetch']) or warn("\e[31m\e[1mcould not pull for\e[0m #{p['name']}")
            end
        end
        puts "\e[1msyncing all Subversion repositories...\e[0m"
        @ldb['projects'].select{|p|p['scm']=='svn'}.each do |p|
            puts "\e[1msync:\e[0m #{p['name']}"
            Dir.chdir(File.join(File.expand_path(PROJECT_DIR), p['name'])) do
                system("svn", "up") or warn("\e[31m\e[1mcould not update\e[0m #{p['name']}")
            end
        end
        puts "\e[1msyncing all Bazaar repositories...\e[0m"
        @ldb['projects'].select{|p|p['scm']=='bzr' and p['do_update']}.each do |p|
            puts "\e[1msync:\e[0m #{p['name']}"
            Dir.chdir(File.join(File.expand_path(PROJECT_DIR), p['name'])) do
                system("bzr", "up") or warn("\e[31m\e[1mcould not update\e[0m #{p['name']}")
            end
        end
        puts "\e[1msyncing all Mercurial repositories...\e[0m"
        @ldb['projects'].select{|p|p['scm']=='hg' and p['do_pull']}.each do |p|
            puts "\e[1msync:\e[0m #{p['name']}"
            Dir.chdir(File.join(File.expand_path(PROJECT_DIR), p['name'])) do
                system("hg", "pull") or warn("\e[31m\e[1mcould not pull for\e[0m #{p['name']}")
            end
        end
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def svn_get(pname, svn_url)
        puts "\e[1msvn-get:\e[0m #{pname} \e[1mfrom:\e[0m #{svn_url}"
        puts "\e[1mcheckout\e[0m #{svn_url} \e[1minto\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname)}"
        return warn("\e[31m\e[1msvn checkout failed.\e[0m") unless system("svn", "checkout", svn_url, File.join(File.expand_path(PROJECT_DIR), pname))
        puts "\e[1madd\e[0m #{pname} \e[1mto database as SVN repository\e[0m"
        @ldb['projects'] << {'name' => pname, 'type' => nil, 'scm' => 'svn'}
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def git_get(pname, git_url)
        puts "\e[1mgit-get:\e[0m #{pname} \e[1mfrom:\e[0m #{git_url}"
        puts "\e[1mclone\e[0m #{git_url} \e[1minto\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname)}"
        return warn("\e[31m\e[1mgit clone failed.\e[0m") unless system("git", "clone", git_url, File.join(File.expand_path(PROJECT_DIR), pname))
        puts "\e[1madd\e[0m #{pname} \e[1mto database as GIT repository\e[0m"
        @ldb['projects'] << {'name' => pname, 'type' => nil, 'scm' => 'git', 'fetch' => 'origin'}
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def bzr_get(pname, bzr_url)
        puts "\e[1mbzr-get:\e[0m #{pname} \e[1mfrom:\e[0m #{bzr_url}"
        puts "\e[1mcheckout\e[0m #{bzr_url} \e[1minto\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname)}"
        return warn("\e[31mbzr checkout failed.\e[0m") unless system("bzr", "checkout", bzr_url, File.join(File.expand_path(PROJECT_DIR), pname))
        puts "\e[1madd\e[0m #{pname} \e[1mto database as BZR repository\e[0m"
        @ldb['projects'] << {'name' => pname, 'type' => nil, 'scm' => 'bzr', 'do_update' => true}
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def hg_get(pname, hg_url)
        puts "\e[1mhg-get:\e[0m #{pname} \e[1mfrom:\e[0m #{hg_url}"
        puts "\e[1mclone\e[0m #{hg_url} \e[1minto\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname)}"
        return warn("\e[31m\e[1mhg clone failed.\e[0m") unless system("hg", "clone", hg_url, File.join(File.expand_path(PROJECT_DIR), pname))
        puts "\e[1madd\e[0m #{pname} \e[1mto database as HG repository\e[0m"
        @ldb['projects'] << {'name' => pname, 'type' => nil, 'scm' => 'hg', 'do_pull' => true}
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def git_init(pname)
        puts "\e[1mgit-init:\e[0m #{pname}"
        p = @ldb['projects'].select{|p|p['name'] == pname}.first
        return(warn("\e[31m\e[1mproject not found.\e[0m")) unless p
        puts "\e[1mchdir\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname)}"
        Dir.chdir(File.join(File.expand_path(PROJECT_DIR), pname)) do
            puts "\e[1mgit init\e[0m"
            system('git', 'init') or return(warn("\e[31mfailed to initialize.\e[0m"))
        end
        puts "\e[1mset\e[0m \"#{pname}\".scm \e[1mto GIT\e[0m"
        p['scm'] = 'git'
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def bzr_init(pname)
        puts "\e[1mbzr-init:\e[0m #{pname}"
        p = @ldb['projects'].select{|p|p['name'] == pname}.first
        return(warn("\e[31m\e[1mproject not found.\e[0m")) unless p
        puts "\e[1mchdir\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname)}"
        Dir.chdir(File.join(File.expand_path(PROJECT_DIR), pname)) do
            puts "\e[1mbzr init\e[0m"
            system('bzr', 'init') or return(warn("\e[31mfailed to initialize.\e[0m"))
        end
        puts "\e[1mset\e[0m \"#{pname}\".scm \e[1mto BZR\e[0m"
        p['scm'] = 'bzr'
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def hg_init(pname)
        puts "\e[1mhg-init:\e[0m #{pname}"
        p = @ldb['projects'].select{|p|p['name'] == pname}.first
        return(warn("\e[31m\e[1mproject not found.\e[0m")) unless p
        puts "\e[1mchdir\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname)}"
        Dir.chdir(File.join(File.expand_path(PROJECT_DIR), pname)) do
            puts "\e[1mhg init\e[0m"
            system('hg', 'init') or return(warn("\e[31mfailed to initialize.\e[0m"))
        end
        puts "\e[1mset\e[0m \"#{pname}\".scm \e[1mto HG\e[0m"
        p['scm'] = 'hg'
        puts "\e[32m\e[1mdone!\e[0m"
        return true
    end
    def skel_ruby(pname, *classes)
        puts "\e[1mskel-ruby:\e[0m #{pname}"
        p = @ldb['projects'].select{|p|p['name'] == pname}.first
        return(warn("\e[31m\e[1mproject not found.\e[0m")) unless p
        puts "\e[1mappend a skeleton for\e[0m #{pname.rubyize} \e[1mto\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname, "main.rb")}"
        File.open(File.join(File.expand_path(PROJECT_DIR), pname, "main.rb"), 'a') do |f|
            f.write "\nmodule #{pname.rubyize}\n#{classes.collect{|c|"\tclass #{c.rubyize}\n\t\t\n\tend\n"}.join}end\n"
        end
        puts "\e[1mchange type to\e[0m ruby"
        p['type'] = 'ruby'
        puts "\e[32m\e[1mdone!\e[0m"
    end
    def skel_shoes(pname)
        puts "\e[1mskel-shoes:\e[0m #{pname}"
        p = @ldb['projects'].select{|p|p['name'] == pname}.first
        return(warn("\e[31m\e[1mproject not found.\e[0m")) unless p
        puts "\e[1mappend a skeleton for\e[0m #{pname.rubyize} < Shoes \e[1mto\e[0m #{File.join(File.expand_path(PROJECT_DIR), pname, "main.shoes.rb")}"
        File.open(File.join(File.expand_path(PROJECT_DIR), pname, "main.shoes.rb"), 'a') do |f|
            f.write "\nclass #{pname.rubyize} < Shoes\n\turl '/', :index\n\tdef index\n\t\tpara 'leafman rules'\n\tend\nend\n"
        end
        puts "\e[1mchange type to\e[0m shoes"
        p['type'] = 'shoes'
        puts "\e[32m\e[1mdone!\e[0m"
    end
    def skel_rails(pname, *rails_opts)
        puts "\e[1mskel-rails:\e[0m #{pname}"
        p = @ldb['projects'].select{|p|p['name'] == pname}.first
        return(warn("\e[31m\e[1mproject not found.\e[0m")) unless p
        puts "\e[1mrun \e[0m'rails'\e[1m on project dir\e[0m"
        Dir.chdir(File.join(File.expand_path(PROJECT_DIR), pname)) do
            run = ["rails"]
            run += rails_opts
            run << "."
            system *run
        end
        puts "\e[1mchange type to\e[0m rails"
        p['type'] = 'rails'
        puts "\e[32m\e[1mdone!\e[0m"
    end
    def proj_import(dir)
        puts "\e[1mimport:\e[0m #{File.basename(dir)}"
        FileUtils.cp_r File.expand_path(dir), File.join(File.expand_path(PROJECT_DIR), File.basename(dir)), :verbose => true
        puts "\e[1madd\e[0m #{File.basename(dir)} \e[1mto database\e[0m"
        @ldb['projects'] << {'name' => File.basename(dir), 'type' => nil, 'scm' => nil}
        puts "\e[32m\e[1mdone!\e[0m"
    end
    def proj_import_git(dir)
        puts "\e[1mimport-git:\e[0m #{File.basename(dir)}"
        FileUtils.cp_r File.expand_path(dir), File.join(File.expand_path(PROJECT_DIR), File.basename(dir)), :verbose => true
        puts "\e[1madd\e[0m #{File.basename(dir)} \e[1mto database as GIT repository.\e[0m"
        @ldb['projects'] << {'name' => File.basename(dir), 'type' => nil, 'scm' => 'git'}
        puts "\e[32m\e[1mdone!\e[0m"
    end
    def proj_import_svn(dir)
        puts "\e[1mimport-svn:\e[0m #{File.basename(dir)}"
        FileUtils.cp_r File.expand_path(dir), File.join(File.expand_path(PROJECT_DIR), File.basename(dir)), :verbose => true
        puts "\e[1madd\e[0m #{File.basename(dir)} \e[1mto database as SVN repository.\e[0m"
        @ldb['projects'] << {'name' => File.basename(dir), 'type' => nil, 'scm' => 'svn'}
        puts "\e[32m\e[1mdone!\e[0m"
    end
    def proj_import_bzr(dir)
        puts "\e[1mimport-bzr:\e[0m #{File.basename(dir)}"
        FileUtils.cp_r File.expand_path(dir), File.join(File.expand_path(PROJECT_DIR), File.basename(dir)), :verbose => true
        puts "\e[1madd\e[0m #{File.basename(dir)} \e[1mto database as BZR repository.\e[0m"
        @ldb['projects'] << {'name' => File.basename(dir), 'type' => nil, 'scm' => 'bzr'}
        puts "\e[32m\e[1mdone!\e[0m"
    end
    def proj_import_hg(dir)
        puts "\e[1mimport-hg:\e[0m #{File.basename(dir)}"
        FileUtils.cp_r File.expand_path(dir), File.join(File.expand_path(PROJECT_DIR), File.basename(dir)), :verbose => true
        puts "\e[1madd\e[0m #{File.basename(dir)} \e[1mto database as HG repository.\e[0m"
        @ldb['projects'] << {'name' => File.basename(dir), 'type' => nil, 'scm' => 'hg'}
        puts "\e[32m\e[1mdone!\e[0m"
    end
end
if __FILE__ == $0
    Leafman.parse_args *ARGV.dup
end


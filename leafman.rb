# Leafman: The GREEN MEAN Managing MACHINE!
#     $ ruby leafman.rb init # Initialize the directories, etc. Use for first time.
#     $ ruby leafman.rb create MyProject # make an empty project with name MyProject
#     $ ruby leafman.rb destroy MyProject # scrap the project with name MyProject
#     $ ruby leafman.rb list # Project Listing
#     $ ruby leafman.rb show MyProject # show all information about MyProject
#     $ ruby leafman.rb fork OtherProject git://example.com/otherproject.git # clone the repository named OtherProject using GIT at git://example.com/otherproject.git
#     $ ruby leafman.rb sync # fetches all changes from the server using GIT.

require 'yaml'
require 'fileutils'
module Leafman; extend self
    PROJECT_DIR = "~/Projects"
    def load_ldb
        @ldb = YAML.load(File.read(File.join(File.expand_path(PROJECT_DIR), ".leafman")))
    end
    def save_ldb
        File.open(File.join(File.expand_path(PROJECT_DIR), ".leafman"), "w") {|f| f.write YAML.dump(@ldb)}
    end
    def parse_args(*argv)
        puts "\e[1m\e[36mL \e[32mE \e[33mA \e[36mF \e[32mM \e[33mA \e[36mN\e[0m, The GREEN MEAN Managing MACHINE!" if argv[0] =~ /^init$/i
        load_ldb rescue warn("\e[33mCould not load the Leafman database. Ignore this if you are running an INIT.\e[0m")
        case argv[0]
            when /^init$/i
                init
            when /^create$/i
                create argv[1]
            when /^destroy$/i
                destroy argv[1]
            when /^list$/i
                list
            when /^show$/i
                show argv[1]
            when /^fork$/i
                git_fork argv[1], argv[2]
            when /^sync$/i
                git_sync_all
            when /^help$/i
                puts "\e[1mNo help yet. Coming in a future release\e[0m"
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
    end
    def show(pname)
        @ldb['projects'].select{|p|p['name'] == pname}.first.each do |k,v|
            puts "\e[1m#{k}\e[0m\t\t= #{v.inspect}"
        end
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
    def git_sync_all
        puts "\e[1mSyncing all GIT repositories...\e[0m"
        @ldb['projects'].select{|p|p['scm']=='git'}.each do |p|
            puts "\e[1msync:\e[0m #{p['name']}"
            Dir.chdir(File.join(File.expand_path(PROJECT_DIR), p['name'])) do
                system("git", "pull", p['fetch']) or warn("\e[31m\e[1mcould not pull for\e[0m #{p['name']}")
            end
        end
        puts "\e[32m\e[1mdone!\e[0m"
    end
end
if __FILE__ == $0
    Leafman.parse_args *ARGV
end


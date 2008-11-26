Leafman::Command.new "git-get", "<project-name> <git-url>", "clone the Git project called <project-name> at <git-url>" do |pname, git_url|
    include Leafman::Mixin
    puts "\e[1mgit-get:\e[0m #{pname} \e[1mfrom:\e[0m #{git_url}"
    puts "\e[1mclone\e[0m #{git_url} \e[1minto\e[0m #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    return warn("\e[31m\e[1mgit clone failed.\e[0m") unless system("git", "clone", git_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    puts "\e[1mcreate project config\e[0m"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'git', 'fetch' => 'origin')
    puts "\e[32m\e[1mdone!\e[0m"
end

Leafman::Command.new "git-fork", "<project-name> <git-url>", "fork the Git project called <project-name> at <git-url>" do |pname, git_url|
    include Leafman::Mixin
    puts "\e[1mgit-fork:\e[0m #{pname} \e[1mfrom:\e[0m #{git_url}"
    puts "\e[1mclone\e[0m #{git_url} \e[1minto\e[0m #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    warn("\e[31m\e[1mgit clone failed.\e[0m")||true&&next unless system("git", "clone", "-o", "forked_from", git_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    puts "\e[1mcreate project config\e[0m"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'git', 'fetch' => 'forked_from')
    puts "\e[32m\e[1mdone!\e[0m"
end

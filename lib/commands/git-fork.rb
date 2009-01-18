Leafman::Command.new "git-fork", "<project-name> <git-url>", "fork the Git project called <project-name> at <git-url>" do |pname, git_url|
    include Leafman::Mixin
    title "git-fork: #{pname} from: #{git_url}"
    task "clone #{git_url} into #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    error("git clone failed.")||true&&next unless system("git", "clone", "-o", "forked_from", git_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    task "create project config"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'git', 'fetch' => 'forked_from')
    finished
end

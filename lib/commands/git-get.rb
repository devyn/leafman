Leafman::Command.new "git-get", "<project-name> <git-url>", "clone the Git project called <project-name> at <git-url>" do |pname, git_url|
    include Leafman::Mixin
    title "git-get: #{pname} from: #{git_url}"
    task "clone #{git_url} into #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    return error("git clone failed.") unless system("git", "clone", git_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    task "create project config"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'git', 'fetch' => 'origin')
    finished
end

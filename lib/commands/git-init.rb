Leafman::Command.new "git-init", "<project-name>", "initialize <project-name> as a Git repository" do |pname|
    include Leafman::Mixin
    title "git-init: #{pname}"
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    command "chdir #{p.dir}"
    Dir.chdir(p.dir) do
        command "git init"
        system('git', 'init') or (error("failed to initialize.")||true&&next)
    end
    task "set SCM to GIT"
    p['scm'] = 'git'
    finished
end

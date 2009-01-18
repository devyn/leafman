Leafman::Command.new "hg-init", "<project-name>", "initialize <project-name> as a Mercurial repository" do |pname|
    include Leafman::Mixin
    title "hg-init: #{pname}"
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    command "chdir #{p.dir}"
    Dir.chdir(p.dir) do
        command "hg init"
        system('hg', 'init') or (error("failed to initialize.")||true&&next)
    end
    task "set SCM to hg"
    p['scm'] = 'hg'
    finished
end

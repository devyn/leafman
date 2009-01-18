Leafman::Command.new "bzr-init", "<project-name>", "initialize <project-name> as a Bazaar repository" do |pname|
    include Leafman::Mixin
    title "bzr-init: #{pname}"
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    command "chdir #{p.dir}"
    Dir.chdir(p.dir) do
        command "bzr init"
        system('bzr', 'init') or (error("failed to initialize.")||true&&next)
    end
    task "set SCM to BZR"
    p['scm'] = 'bzr'
    finished
end

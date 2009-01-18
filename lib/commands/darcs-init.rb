Leafman::Command.new "darcs-init", "<project-name>", "initialize <project-name> as a Darcs repository" do |pname|
    include Leafman::Mixin
    title "darcs-init: #{pname}"
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    command "chdir #{p.dir}"
    Dir.chdir(p.dir) do
        command "darcs initialize"
        system('darcs', 'initialize') or (error("failed to initialize.")||true&&next)
    end
    task "set SCM to Darcs"
    p['scm'] = 'darcs'
    finished
end

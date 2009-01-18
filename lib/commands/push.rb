Leafman::Command.new "push", "[project-names...]", "pushes all distributed enabled projects or [project-names...] to the server" do |*pnames|
    include Leafman::Mixin
    title "pushing projects"
    Leafman::Projects.each(*pnames) do |p|
        if p['scm'] and (p['scm'] != 'svn') and p['do_push']
            task "push: #{p.scm_color}#{p['name']}\e[0m"
            scm_spec = []
            scm_spec << 'origin' if p['scm'] == 'git'
            Dir.chdir(File.join(File.expand_path(Leafman::PROJECT_DIR), p['name'])) do
                system p['scm'], 'push', *scm_spec
            end
        end
    end
    finished
end

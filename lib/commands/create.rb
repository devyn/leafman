Leafman::Command.new "create", "<project-name>", "create a new project called <project-name>" do |pname|
    include Leafman::Mixin
    title "create: #{pname}"
    pdir = File.join(File.expand_path(Leafman::PROJECT_DIR), pname)
    command "mkdir -p \"#{pdir}\""
    FileUtils.mkdir_p pdir
    task "create project config"
    Leafman::Projects.add(pname, 'scm' => nil, 'type' => nil)
    finished
end

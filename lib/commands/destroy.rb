Leafman::Command.new "destroy", "<project-name>", "destroy the project called <project-name>" do |pname|
    include Leafman::Mixin
    title "destroy: #{pname}"
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    command "rm -rf \"#{p.dir}\""
    FileUtils.rm_rf p.dir
    command "rm \"#{p.conf_file_path}\""
    FileUtils.rm    p.conf_file_path
    finished
end

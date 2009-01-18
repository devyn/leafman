Leafman::Command.new "darcs-get", "<project-name> <hg-url>", "get the Darcs project called <project-name> at <darcs-url>" do |pname, hg_url|
    include Leafman::Mixin
    title "darcs-get: #{pname} from: #{darcs_url}"
    task "get #{hg_url} into #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    return error("darcs get failed.") unless system("darcs", "get", hg_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    task "create project config"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'darcs', 'do_pull' => true)
    finished
end

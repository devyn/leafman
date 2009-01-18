Leafman::Command.new "hg-get", "<project-name> <hg-url>", "clone the Mercurial project called <project-name> at <hg-url>" do |pname, hg_url|
    include Leafman::Mixin
    title "hg-get: #{pname} from: #{hg_url}"
    task "clone #{hg_url} into #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    return error("hg clone failed.") unless system("hg", "clone", hg_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    task "create project config"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'hg', 'do_pull' => true)
    finished
end

Leafman::Command.new "bzr-get", "<project-name> <bzr-url>", "checkout the Bazaar project called <project-name> at <bzr-url>" do |pname, git_url|
    include Leafman::Mixin
    title "bzr-get: #{pname} from: #{bzr_url}"
    task "checkout #{bzr_url} into #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    return error("bzr checkout failed.") unless system("bzr", "checkout", bzr_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    task "create project config"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'bzr', 'do_update' => true)
    finished
end

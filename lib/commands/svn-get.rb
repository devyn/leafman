Leafman::Command.new "svn-get", "<project-name> <svn-url>", "checkout the Subversion project called <project-name> at <svn-url>" do |pname, svn_url|
    include Leafman::Mixin
    title "svn-get: #{pname} from: #{svn_url}"
    task "checkout #{svn_url} into #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    return error("svn checkout failed.") unless system("svn", "checkout", svn_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    task "create project config"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'svn', 'do_update' => true)
    finished
end

Leafman::Command.new "import", "<directory>", "import <directory> as a project, then auto-detect it's SCM" do |dir|
    include Leafman::Mixin
    title "import: #{File.basename(dir)}"
    FileUtils.cp_r File.expand_path(dir), File.join(File.expand_path(Leafman::PROJECT_DIR), File.basename(dir)), :verbose => true
    task "creating project config"
    p = Leafman::Projects.add(File.basename(dir), 'type' => nil, 'scm' => nil)
    task "auto-detecting project info"
    p.detect
    p.ro_hash.each{|k,v|list_item "#{k}: #{v.inspect}"}
    finished
end

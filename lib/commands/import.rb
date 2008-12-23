Leafman::Command.new "import", "<directory>", "import <directory> as a project, then auto-detect it's SCM" do |dir|
    include Leafman::Mixin
    puts "\e[1mimport:\e[0m #{File.basename(dir)}"
    FileUtils.cp_r File.expand_path(dir), File.join(File.expand_path(Leafman::PROJECT_DIR), File.basename(dir)), :verbose => true
    puts "\e[1mcreating project config\e[0m"
    p = Leafman::Projects.add(File.basename(dir), 'type' => nil, 'scm' => nil)
    puts "\e[1mauto-detecting project info\e[0m"
    p.detect
    puts *p.ro_hash.map{|k,v|"#{k}: #{v.inspect}"}
    puts "\e[32m\e[1mdone!\e[0m"
end

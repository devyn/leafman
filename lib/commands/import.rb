Leafman::Command.new "import", "<directory>", "import <directory> as a project, then auto-detect it's SCM" do |dir|
    include Leafman::Mixin
    puts "\e[1mimport:\e[0m #{File.basename(dir)}"
    FileUtils.cp_r File.expand_path(dir), File.join(File.expand_path(Leafman::PROJECT_DIR), File.basename(dir)), :verbose => true
    print "\e[1mauto-detect SCM:\e[0m "
    scm = nil
    scm = 'git' if File.directory?(File.join(File.expand_path(Leafman::PROJECT_DIR), File.basename(dir), ".git"))
    scm = 'svn' if File.directory?(File.join(File.expand_path(Leafman::PROJECT_DIR), File.basename(dir), ".svn"))
    scm = 'bzr' if File.directory?(File.join(File.expand_path(Leafman::PROJECT_DIR), File.basename(dir), ".bzr"))
    scm = 'hg' if File.directory?(File.join(File.expand_path(Leafman::PROJECT_DIR), File.basename(dir), ".hg"))
    scm = 'darcs' if File.directory?(File.join(File.expand_path(Leafman::PROJECT_DIR), File.basename(dir), "_darcs"))
    puts((scm or 'none').upcase)
    puts "\e[1mcreate project config\e[0m"
    Leafman::Projects.add(File.basename(dir), 'type' => nil, 'scm' => scm)
    puts "\e[32m\e[1mdone!\e[0m"
end

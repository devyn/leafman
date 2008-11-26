Leafman::Command.new "bzr-get", "<project-name> <bzr-url>", "checkout the Bazaar project called <project-name> at <bzr-url>" do |pname, git_url|
    include Leafman::Mixin
    puts "\e[1mbzr-get:\e[0m #{pname} \e[1mfrom:\e[0m #{bzr_url}"
    puts "\e[1mcheckout\e[0m #{bzr_url} \e[1minto\e[0m #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    return warn("\e[31m\e[1mbzr checkout failed.\e[0m") unless system("bzr", "checkout", bzr_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    puts "\e[1mcreate project config\e[0m"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'bzr', 'do_update' => true)
    puts "\e[32m\e[1mdone!\e[0m"
end

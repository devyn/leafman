Leafman::Command.new "svn-get", "<project-name> <svn-url>", "checkout the Subversion project called <project-name> at <svn-url>" do |pname, svn_url|
    include Leafman::Mixin
    puts "\e[1msvn-get:\e[0m #{pname} \e[1mfrom:\e[0m #{svn_url}"
    puts "\e[1mcheckout\e[0m #{svn_url} \e[1minto\e[0m #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    return warn("\e[31m\e[1msvn checkout failed.\e[0m") unless system("svn", "checkout", svn_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    puts "\e[1mcreate project config\e[0m"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'svn', 'do_update' => true)
    puts "\e[32m\e[1mdone!\e[0m"
end

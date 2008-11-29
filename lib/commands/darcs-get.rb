Leafman::Command.new "darcs-get", "<project-name> <hg-url>", "get the Darcs project called <project-name> at <darcs-url>" do |pname, hg_url|
    include Leafman::Mixin
    puts "\e[1mdarcs-get:\e[0m #{pname} \e[1mfrom:\e[0m #{darcs_url}"
    puts "\e[1mget\e[0m #{hg_url} \e[1minto\e[0m #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    return warn("\e[31m\e[1mdarcs get failed.\e[0m") unless system("darcs", "get", hg_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    puts "\e[1mcreate project config\e[0m"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'darcs', 'do_pull' => true)
    puts "\e[32m\e[1mdone!\e[0m"
end

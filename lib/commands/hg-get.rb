Leafman::Command.new "hg-get", "<project-name> <hg-url>", "clone the Mercurial project called <project-name> at <hg-url>" do |pname, hg_url|
    include Leafman::Mixin
    puts "\e[1mhg-get:\e[0m #{pname} \e[1mfrom:\e[0m #{hg_url}"
    puts "\e[1mclone\e[0m #{hg_url} \e[1minto\e[0m #{File.join(File.expand_path(Leafman::PROJECT_DIR), pname)}"
    return warn("\e[31m\e[1mhg clone failed.\e[0m") unless system("hg", "clone", hg_url, File.join(File.expand_path(Leafman::PROJECT_DIR), pname))
    puts "\e[1mcreate project config\e[0m"
    Leafman::Projects.add(pname, 'type' => nil, 'scm' => 'hg', 'do_pull' => true)
    puts "\e[32m\e[1mdone!\e[0m"
end

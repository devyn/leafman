Leafman::Command.new "list", "", "list of all projects" do
    include Leafman::Mixin
    puts "\e[1mproject listing\e[0m"
    Leafman::Projects.each do |p|
        scm_code = ''
        case p['scm']
            when 'git'
                scm_code = "\e[32m"
            when 'svn'
                scm_code = "\e[34m"
            when 'bzr'
                scm_code = "\e[33m"
            when 'hg'
                scm_code = "\e[36m"
        end
        puts "\e[1m*\e[0m\t#{scm_code}#{p['name']}\e[0m"
    end
end

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
            when 'darcs'
                scm_code = "\e[35m"
        end
        fetchable = false
        case p['scm']
            when 'git'
                fetchable = p['fetch']
            when 'svn'
                fetchable = p['do_update']
            when 'bzr'
                fetchable = p['do_update']
            when 'hg'
                fetchable = p['do_pull']
            when 'darcs'
                fetchable = p['do_pull']
        end
        pushable = p['do_push']
        eestr = nil
        if pushable and fetchable
            eestr = '><'
        elsif pushable
            eestr = '>>'
        elsif fetchable
            eestr = '<<'
        else
            eestr = '**'
        end
        puts "\e[1m#{eestr}\e[0m\t#{scm_code}#{p['name']}\e[0m"
    end
end

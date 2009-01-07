require 'set'
Leafman::Command.new "list", "[category]", "list of all categories / projects" do |*cat|
    include Leafman::Mixin
    if cat[0]
        puts "\e[1m#{cat[0]} listing\e[0m"
        cat[0] = nil if cat[0] == 'general'
        Leafman::Projects.each do |p|
            next unless p['category'] == cat[0]
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
                else
                    fetchable = p['synkage_url']
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
    else
        puts "\e[1mcategory listing\e[0m"
        categories = Set.new
        Leafman::Projects.each do |p|
            categories << (p['category'] or 'general')
        end
        categories.sort.each do |c|
            puts "\e[1m*\e[0m\t#{c}"
        end
    end
end

Leafman::Command.new "popularity-contest", "", "shows the percentages of each scm." do
    include Leafman::Mixin
    title "popularity contest"
    t, g, s, b, h, d, o = [0]*7
    Leafman::Projects.each do |p|
        t += 1
        case p['scm']
            when 'git'
                g += 1
            when 'svn'
                s += 1
            when 'bzr'
                b += 1
            when 'hg'
                h += 1
            when 'darcs'
                d += 1
            else
                o += 1
        end
    end
    log "total projects found: #{t}"
    {"\e[32mGit\e[0m" => g, "\e[34mSubversion\e[0m" => s, "\e[33mBazaar\e[0m" => b, "\e[36mMercurial\e[0m" => h, "\e[35mDarcs\e[0m" => d, "Other" => o}.sort{|a1,a2|(a1[1] <=> a2[1])*-1}.each do |a|
        k,v = a
        log "#{k}: #{((v/t.to_f)*100).to_s[0..3]}%"
    end
end

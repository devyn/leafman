Leafman::Command.new "commit", "<project-name> <change-category> <summary> [changelog-entry...]", "commit a change in <change-category> using the Leafman universal commit message format" do |pname, category, summary, *changelog_entries|
    include Leafman::Mixin
    title "commit to [#{category}]"
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    msg = "[#{category}] #{summary}"
    changelog_entries.each do |ent|
        msg << "\n* #{ent}"
    end
    case p['scm']
    when 'git', 'svn', 'bzr', 'hg'
        command "#{p['scm']} commit -m ..."
        system p['scm'], 'commit', '-m', msg
    when 'darcs'
        command "darcs record -m ..."
        system 'darcs', 'record', '-m', msg
    else
        error("not available for any SCM other than Git, Subversion, Bazzar, Mercurial or Darcs.")||true&&next
    end
    msg.each_line{|ln|log ln}
    finished
end

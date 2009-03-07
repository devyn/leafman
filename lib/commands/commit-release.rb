Leafman::Command.new "commit-release", "<project-name> <name|version> <summary> [changelog-entry...]", "commit a new release called <name|version> using the Leafman universal commit message format" do |pname, name_or_version, summary, *changelog_entries|
    include Leafman::Mixin
    title "commit release #{name_or_version}"
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    msg = "::: release #{name_or_version}: #{summary} :::"
    changelog_entries.each do |ent|
        msg << "\n* #{ent}"
    end
    case p['scm']
    when 'git', 'svn', 'bzr', 'hg'
        (error("command execution failed"); next) unless run_command(p['scm'], 'commit', '-m', msg)
    when 'darcs'
        (error("command execution failed"); next) unless run_command('darcs', 'record', '-m', msg)
    else
        error("not available for any SCM other than Git, Subversion, Bazzar, Mercurial, or Darcs."); next
    end
    case p['scm']
    # sorry, no subversion
    when 'git', 'bzr', 'hg', 'darcs'
        (error("command execution failed"); next) unless run_command(p['scm'], 'tag', name_or_version)
    end
    msg.each_line{|ln|log ln}
    finished
end

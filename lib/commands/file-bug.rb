Leafman::Command.new "file-bug", "<project-name> <bug>", "Add a bug to <project-name> -- this shows up on what-to-do and show" do |pname, bug|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    p['bugs'] = [] unless p['bugs']
    p['bugs'] += [bug]
end

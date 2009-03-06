Leafman::Command.new "add-task", "<project-name> <task>", "add a task to <project-name> -- this shows up on what-to-do and show" do |pname, task|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    p['todos'] = [] unless p['todos']
    p['todos'] += [task]
end

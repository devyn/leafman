Leafman::Command.new "add-task", "<project-name> <task>", "Add a task to <project-name> -- this shows up on what-to-do and show" do |pname, task|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    p['todos'] = [] unless p['todos']
    p['todos'] += [task]
end

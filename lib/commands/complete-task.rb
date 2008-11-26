Leafman::Command.new "complete-task", "<project-name> <number>", "complete a task on <project-name> with <number> (ex. t0, t1, t2...)" do |pname, num|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    if num =~ /^b(\d+)$/i
        p['bugs'] -= [p['bugs'][$1.to_i]] if p['bugs']
    elsif num =~ /^t(\d+)$/i
        p['todos'] -= [p['todos'][$1.to_i]] if p['todos']
    else
        warn("\e[31m\e[1minvalid number.\e[0m")||true&&next
    end
end

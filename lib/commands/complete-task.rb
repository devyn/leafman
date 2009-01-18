Leafman::Command.new "complete-task", "<project-name> <number>", "complete a task on <project-name> with <number> (ex. t0, t1, t2...)" do |pname, num|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    if num =~ /^b(\d+)$/i
        p['bugs'] -= [p['bugs'][$1.to_i]] if p['bugs']
    elsif num =~ /^t(\d+)$/i
        p['todos'] -= [p['todos'][$1.to_i]] if p['todos']
    else
        error("invalid number.")||true&&next
    end
end

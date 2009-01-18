Leafman::Command.new "fix-bug", "<project-name> <number>", "fix a bug on <project-name> with <number> (ex. b0, b1, b2...)" do |pname, num|
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

Leafman::Command.new "set-description", "<project-name>", "set the description for <project-name>", "configuration" do |pname|
    include Leafman::Mixin
    p = Leafman::Projects.find pname
    error("project not found.")||true&&next unless p
    ask "Please type the description for #{p['name']}:"
    p['description'] = $stdin.read
end

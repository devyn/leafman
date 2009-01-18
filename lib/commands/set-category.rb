Leafman::Command.new "set-category", "<project-name> <category>", "set the category of <project-name>", "configuration" do |pname, cat|
    include Leafman::Mixin
    cat = nil if cat == 'general'
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    p['category'] = cat
end

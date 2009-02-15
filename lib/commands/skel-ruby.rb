Leafman::Command.new "skel-ruby", "<project-name> [classes...]", "generate a Ruby skeleton (with class skeletons) for <project-name>, then set the 'type' accordingly" do |pname, *classes|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next  unless p
    title "generate Ruby skeleton for #{p['name']}"
    require 'ext/ruby_builder'
    rb = RubyBuilder.new
    rb.namespace p['name'].gsub('/', '::').gsub(/^./){|rc| rc.upcase}.gsub(/_./){|rc| rc.upcase}.gsub(/::./){|rc| rc.upcase} do
        classes.each do |cls|
            task "adding class stub #{cls}"
            type cls do
                method('initialize') { comment "TODO: insert your initialization code here..." }
            end
        end
    end
    File.open(p.dir("#{p['name']}.rb"), 'w') {|f| f.write rb.build}
end

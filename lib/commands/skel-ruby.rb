class String
    def rubyize
        self.gsub('/', '::').gsub(/^./){|rc| rc.upcase}.gsub(/_./){|rc| rc.upcase}.gsub(/::./){|rc| rc.upcase}
    end
end
Leafman::Command.new "skel-ruby", "<project-name> [classes...]", "generate a Ruby skeleton (with class skeletons) for <project-name>, then set the 'type' accordingly" do |pname, *classes|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next  unless p
    title "generate Ruby skeleton for #{p['name']}"
    require 'ext/ruby_builder'
    code = RubyBuilder.new do
        namespace p['name'].rubyize do
            classes.each do |clsu|
                cls = clsu.split(":")
                task "adding class stub #{cls[0]}"
                type cls[0] do
                    cls[1..-1].each do |m|
                        if m =~ /^@/
                            log "adding attribute stub #{cls[0]}##{m.sub(/^@/,'')}"
                            self << "attr_accessor #{m.sub(/^@/,':')}"
                        else
                            log "adding method stub #{cls[0]}##{m}"
                            method(m) { comment "TODO: write this code (#{m})" }
                        end
                    end
                end
            end
        end
    end.build
    File.open(p.dir("#{p['name']}.rb"), 'w') {|f| f.write code}
end

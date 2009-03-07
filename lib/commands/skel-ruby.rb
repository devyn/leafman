class String
    def rubyize
        self.gsub('/', '::').gsub(/^./){|rc| rc.upcase}.gsub(/_(.)/){$1.upcase}.gsub(/::./){|rc| rc.upcase}
    end
end
Leafman::Command.new "skel-ruby", "<project-name> [classes...]", "generate a Ruby skeleton (with class skeletons) for <project-name>, then set the 'type' accordingly" do |pname, *classes|
    include Leafman::Mixin
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next  unless p
    title "generate Ruby skeleton for #{p['name']}"
    require 'ext/ruby_builder'
    Dir.mkdir(p.dir('lib'))
    files = []
    classes.each do |clsu|
        cls = clsu.split(":")
        task "adding class stub for: #{p['name'].rubyize}::#{cls[0].rubyize}"
        files << File.join('lib', "#{cls[0]}.rb")
        File.open(p.dir(files[-1]), 'w') do |f|
            code = RubyBuilder.new do
                namespace p['name'].rubyize do
                    type cls[0].rubyize do
                        cls[1..-1].each do |m|
                            if m =~ /^@/
                                log "adding attribute: #{m}"
                                self << "attr_accessor #{m.sub(/^@/, ':')}"
                            else
                                log "adding method:    #{m}"
                                method(m) { comment "TODO: write action code for #{m}" }
                            end
                        end
                    end
                end
            end.build
            f.write code
        end
    end
    File.open(p.dir("#{p['name']}.rb"), 'w') do |f|
        task "generating library index"
        code = RubyBuilder.new do
            comment "code skeleton generated via Leafman (http://www.github.com/devyn/leafman)"
            namespace p['name'].rubyize do
                self << 'extend self'
            end
            self << ''
            self << "$: << File.expand_path(File.dirname(__FILE__))"
            files.each do |fl|
                log "- #{fl}"
                self << "require #{fl.inspect}"
            end
        end.build
        f.write code
    end
end

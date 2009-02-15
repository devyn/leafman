module Stubbl
    def self.gen_stub bl
        rb = RubyBuilder.new
        bl.each_line do |l|
            case l.scan(/^\s*([$%&-])/).flatten.first
            when '$'
                rb.namespace l.scan(/^\s*[$%&-]([A-Za-z0-9_]+)/).flatten.first do end
            when '%'
                rblev1 = rb
                rblev = l.scan(/^\s*/).flatten.first.size/2
                rblev.times {rblev1 = rblev1.contents[-1]}
                rb1 = RubyBuilder.new(rblev1)
                rb1.type l.scan(/^\s*[$%&-]([A-Za-z0-9_]+)/).flatten.first do end
            when '&'
                rblev1 = rb
                rblev = l.scan(/^\s*/).flatten.first.size/2
                rblev.times {rblev1 = rblev1.contents[-1]}
                rb1 = RubyBuilder.new(rblev1)
                rb1.set l.scan(/^\s*[$%&-]([A-Za-z0-9_]+)/).flatten.first, rb1.code(l.scan(/^\s*[$%&-][A-Za-z0-9_]+ (.+)/).flatten.first)
            when '-'
                rblev1 = rb
                rblev = l.scan(/^\s*/).flatten.first.size/2
                rblev.times {rblev1 = rblev1.contents[-1]}
                rb1 = RubyBuilder.new(rblev1)
                rb1.method l.scan(/^\s*[$%&-]([A-Za-z0-9_]+)/).flatten.first, nil, (l.scan(/^\s*[$%&-][A-Za-z0-9_]+ (.*)/).flatten.first ? l.scan(/^\s*[$%&-][A-Za-z0-9_]+ (.*)/).flatten.first.split(" ") : nil) do end
            end
        end
        rb.build
    end
end
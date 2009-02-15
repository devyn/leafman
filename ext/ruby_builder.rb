class RubyBuilder
    class CodeBlock
        def initialize(hsh={})
            hsh[:contents] ||= []
            hsh.each do |k,v|
                self.instance_variable_set "@#{k}", v
            end
        end
        def type
            self.class.type
        end
        def self.type
            :block
        end
        attr_accessor :contents
    end
    class NamedBlock < CodeBlock
        attr_accessor :name
        def make_string
            s = ""
            s << "#{type.to_s} #{name}\n"
            contents.each do |c|
                s << c.make_string.gsub(/^/, "    ")
            end
            s << "end\n"
        end
    end
    class Namespace < NamedBlock
        def self.type
            :module
        end
    end
    class Type < NamedBlock
        attr_accessor :extends
        def self.type
            :class
        end
        def make_string
            s = ""
            s << "#{type.to_s} #{name}#{" < #{extends}" if extends}\n"
            contents.each do |c|
                s << c.make_string.gsub(/^/, "    ")
            end
            s << "end\n"
        end
    end
    class Method < NamedBlock
        attr_accessor :scope, :argument_names
        def self.type
            :def
        end
        def make_string
            s = ""
            s << "#{"#{scope}; " if scope}#{type.to_s} #{name}#{" #{argument_names.join(', ')}" if argument_names}\n"
            contents.each do |c|
                s << c.make_string.gsub(/^/, "    ")
            end
            s << "end\n"
        end
    end
    class IfBlock < CodeBlock
        attr_accessor :condition, :elseif_blocks, :else_block
        def make_string
            s = ""
            s << "if #{condition.make_string.chomp}\n"
            contents.each do |c|
                s << c.make_string.gsub(/^/, "    ")
            end
            if elseif_blocks
                elseif_blocks.each do |if_blk|
                    s << if_blk.make_string.sub(/^if/, "elsif").gsub(/^/, "    ").sub(/^    /, "")
                end
            end
            if else_block
                s << else_block.sub(/^if/, "else").gsub(/^/, "    ").sub(/^    /, "")
            end
            s << "end\n"
        end
    end
    class DoBlock < CodeBlock
        attr_accessor :argument_names, :to
        def make_string
            s = ""
            s << "#{to.make_string} do"
            s << " |#{argument_names.join(", ")}|"
            s << "\n"
            contents.each do |c|
                s << c.make_string.gsub(/^/, "    ")
            end
            s << "end\n"
        end
    end
    class VariableAssignment
        attr_accessor :name, :assignment
        def initialize(hsh)
            hsh[:assignment] ||= "nil"
            hsh.each do |k,v|
                self.instance_variable_set("@#{k}", v)
            end
        end
        def make_string
            "#{name} = #{assignment.chomp}\n"
        end
    end
    class LOC < String
        def make_string
            chomp + "\n"
        end
    end
    
    attr_accessor :contents
    def initialize(wrapping=nil)
        @wrapping = wrapping
        @wrapping ||= self
        @contents = []
    end
    def build
        @wrapping.contents.collect{|l|l.make_string}.join
    end
    def namespace name, &blk
        ns = Namespace.new(:name => name)
        wrp = self.class.new(ns)
        wrp.instance_eval &blk
        @wrapping.contents << ns
    end
    def type name, extends=nil, &blk
        tp = Type.new(:name => name, :extends => extends)
        wrp = self.class.new(tp)
        wrp.instance_eval &blk
        @wrapping.contents << tp
    end
    def method name, scope=nil, argument_names=nil, &blk
        mt = Method.new(:name => name, :scope => scope, :argument_names => argument_names)
        wrp = self.class.new(mt)
        wrp.instance_eval &blk
        @wrapping.contents << mt
    end
    def <<(this)
        @wrapping.contents << LOC.new(this)
    end
    def comment(c)
        self << "# #{c}"
    end
    def code(this)
        LOC.new(this)
    end
    def conditional(condition, &blk)
        ib = IfBlock.new(:condition => condition)
        wrp = self.class.new(ib)
        wrp.instance_eval &blk
        @wrapping.contents << ib
    end
    def otherwise_if(condition, &blk)
        if @wrapping.is_a? IfBlock
            ib = IfBlock.new(:condition => condition)
            wrp = self.class.new(ib)
            wrp.instance_eval &blk
            @wrapping.elseif_blocks << ib
        end
    end
    def otherwise(&blk)
        if @wrapping.is_a? IfBlock
            ib = IfBlock.new(:condition => "")
            wrp = self.class.new(ib)
            wrp.instance_eval &blk
            @wrapping.else_block = ib
        end
    end
    def set(name, value)
        @wrapping.contents << VariableAssignment.new(:name => name, :assignment => value)
    end
end
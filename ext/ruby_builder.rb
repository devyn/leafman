class String
    def make_string
        chomp + "\n"
    end
end
class RubyBuilder
    class CodeBlock
        def initialize(hsh={})
            cbinit
            hsh[:contents] ||= []
            hsh.each do |k,v|
                self.instance_variable_set "@#{k}", v
            end
        end
        def cbinit; end
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
        def cbinit
            @elseif_blocks = []
        end
        def make_string
            s = ""
            s << "if#{' '+condition.make_string.chomp unless condition.empty?}\n"
            contents.each do |c|
                s << c.make_string.gsub(/^/, "    ")
            end
            if elseif_blocks
                elseif_blocks.each do |if_blk|
                    s << if_blk.make_string.sub(/^if/, "elsif").sub(/end\n$/m, '')
                end
            end
            if else_block
                s << else_block.make_string.sub(/^if/, "else").sub(/end\n$/m, '')
            end
            s << "end\n"
        end
    end
    class DoBlock < CodeBlock
        attr_accessor :argument_names, :to
        def make_string
            s = ""
            s << "#{to.make_string.chomp} do"
            s << " |#{argument_names.join(", ")}|" if argument_names
            s << "\n"
            contents.each do |c|
                s << c.make_string.gsub(/^/, "    ")
            end
            s << "end\n"
        end
    end
    class TryBlock < CodeBlock
        attr_accessor :catches, :finally
        def cbinit
            @catches = []
        end
        def make_string
            s = ""
            s << "begin\n"
            contents.each do |c|
                s << c.make_string.gsub(/^/, "    ")
            end
            if catches
                catches.each do |c|
                    s << c.make_string
                end
            end
            if finally
                s << "ensure\n"
                finally.contents.each do |fs|
                    s << fs.make_string.gsub(/^/, "    ")
                end
            end
            s << "end\n"
        end
    end
    class CatchBlock < CodeBlock
        attr_accessor :exception
        def cbinit
            @exception = ""
        end
        def make_string
            s = ""
            s << "rescue #{exception.make_string}"
            contents.each do |c|
                s << c.make_string.gsub(/^/, "    ")
            end
            s
        end
    end
    class VariableAssignment
        attr_accessor :name, :assignment
        def cbinit
            @assignment = 'nil'
        end
        def make_string
            "#{name} = #{assignment.chomp}\n"
        end
    end
    
    attr_accessor :contents
    def initialize(wrapping=nil, &blk)
        @wrapping = wrapping
        @wrapping ||= self
        @contents = []
        self.instance_eval &blk if block_given?
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
    def block action, argument_names=nil, &blk
        bk = DoBlock.new(:to => action, :argument_names => argument_names)
        wrp = self.class.new(bk)
        wrp.instance_eval &blk
        @wrapping.contents << bk
    end
    alias with block
    def <<(this)
        @wrapping.contents << this
    end
    def comment(c)
        self << "# #{c}"
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
    def try &blk
        tb = TryBlock.new
        wrp = self.class.new(tb)
        wrp.instance_eval &blk
        @wrapping.contents << tb
    end
    def catch exception, &blk
        if @wrapping.is_a? TryBlock
            cb = CatchBlock.new(:exception => exception)
            wrp = self.class.new(cb)
            wrp.instance_eval &blk
            @wrapping.catches << cb
        end
    end
    def finally &blk
        if @wrapping.is_a? TryBlock
            fb = TryBlock.new
            wrp = self.class.new(fb)
            wrp.instance_eval &blk
            @wrapping.finally = fb
        end
    end
end
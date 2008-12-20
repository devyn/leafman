module Leafman
    module Mixin
        def puts(*s); Leafman.puts(*s); end
        def print(*s); Leafman.print(*s); end
        def warn(*s); Leafman.warn(*s); end
        def abort(*s); Leafman.abort(*s); end
    end
    def puts(*s)
        if (@config['colors'] rescue nil)
            Kernel.puts *s
        else
            Kernel.puts *(s.collect{|s|s.gsub(/\e\[\d+m/, '')})
        end
    end
    def print(*s)
        if (@config['colors'] rescue nil)
            Kernel.print *s
        else
            Kernel.print *(s.collect{|s|s.gsub(/\e\[\d+m/, '')})
        end
    end
    def warn(*s)
        if (@config['colors'] rescue nil)
            Kernel.warn *s
        else
            Kernel.warn *(s.collect{|s|s.gsub(/\e\[\d+m/, '')})
        end
    end
    def abort(*s)
        warn *s
        exit 1
    end
    def load_conf
        @config = YAML.load(File.read(File.join(File.expand_path(PROJECT_DIR), ".leafman", "_config")))
    end
    def save_conf
        File.open(File.join(File.expand_path(PROJECT_DIR), ".leafman", "_config"), "w") {|f| f.write YAML.dump(@config)}
    end
end

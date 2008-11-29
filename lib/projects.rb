module Leafman
    PROJECT_DIR = ENV['LEAFMAN_DIR'] || "~/Projects"
    module Projects; extend self
        class Accessor
            def initialize(pname)
                @pname = pname
            end
            def [](k)
                return @pname if k == 'name'
                YAML.load(File.read(File.join(File.expand_path(PROJECT_DIR), @pname, '.leafman-project')))[k]
            end
            def []=(k,v)
                y = YAML.load(File.read(File.join(File.expand_path(PROJECT_DIR), @pname, '.leafman-project')))
                r = y[k]=v
                File.open(File.join(File.expand_path(PROJECT_DIR), @pname, '.leafman-project'), 'w') do |f|
                    f.write YAML.dump(y)
                end
                r
            end
            def delete k
                y = YAML.load(File.read(File.join(File.expand_path(PROJECT_DIR), @pname, '.leafman-project')))
                r = y.delete(k)
                File.open(File.join(File.expand_path(PROJECT_DIR), @pname, '.leafman-project'), 'w') do |f|
                    f.write YAML.dump(y)
                end
                r
            end
        end
        def find pname
            return nil unless pname.is_a? String
            return nil unless File.exists?(File.join(File.expand_path(PROJECT_DIR), pname, '.leafman-project'))
            return Accessor.new(pname)
        end
        def add pname, phash
            File.open(File.join(File.expand_path(PROJECT_DIR), pname, '.leafman-project'), 'w') do |f|
                f.write YAML.dump(phash)
            end
        end
        def each
            names.sort.each do |pname|
                yield Accessor.new(pname)
            end
        end
        def names
            Dir.glob(File.join(File.expand_path(PROJECT_DIR), "*", ".leafman-project")).collect{|d|File.basename(File.dirname(d))}
        end
    end
end

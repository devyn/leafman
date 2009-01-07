module Leafman
    PROJECT_DIR = ENV['LEAFMAN_DIR'] || "~/Projects"
    module Projects; extend self
        class Accessor
            def conf_file_path
                File.join(File.expand_path(PROJECT_DIR), '.leafman', "#@pname.yml")
            end
            def initialize(pname)
                @pname = pname
            end
            def [](k)
                return @pname if k == 'name'
                ro_hash[k]
            end
            def ro_hash
                YAML.load(File.read(conf_file_path))
            end
            def scm_color
                case self['scm']
                    when 'git'
                        return "\e[32m"
                    when 'svn'
                        return "\e[34m"
                    when 'bzr'
                        return "\e[33m"
                    when 'hg'
                        return "\e[36m"
                    when 'darcs'
                        return "\e[35m"
                end
            end
            def []=(k,v)
                y = ro_hash
                r = y[k]=v
                File.open(conf_file_path, 'w') do |f|
                    f.write YAML.dump(y)
                end
                r
            end
            def delete k
                y = YAML.load(File.read(conf_file_path))
                r = y.delete(k)
                File.open(conf_file_path, 'w') do |f|
                    f.write YAML.dump(y)
                end
                r
            end
            def dir(*plus)
                File.join(File.expand_path(PROJECT_DIR), @pname, *plus)
            end
        end
        def find pname
            pname = current if pname == "@@"
            return nil unless pname.is_a? String
            return nil unless File.exists?(File.join(File.expand_path(PROJECT_DIR), '.leafman', "#{pname}.yml"))
            return Accessor.new(pname)
        end
        def current
            return nil unless pr = Dir.pwd.scan(/^#{Regexp.escape(File.expand_path(Leafman::PROJECT_DIR))}\/([^\/]+)/).flatten.first
            pr
        end
        def add pname, phash
            File.open(File.join(File.expand_path(PROJECT_DIR), '.leafman', "#{pname}.yml"), 'w') do |f|
                f.write YAML.dump(phash)
            end
            find pname
        end
        def each(*ns)
            ns = names if ns.empty?
            ns.sort.each do |pname|
                p = find pname
                yield p if p
            end
        end
        def names
            Dir.glob(File.join(File.expand_path(PROJECT_DIR), '.leafman', "*.yml")).collect{|n|n.sub(/^#{Regexp.escape(File.join(File.expand_path(PROJECT_DIR), '.leafman'))}\//, '').sub(/\.yml$/, '')}
        end
    end
end

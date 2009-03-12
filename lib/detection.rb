module Leafman
    class Projects::Accessor
        def detect
            # detect SCM
            self['scm'] =  nil
            self['scm'] = 'git'   if File.directory?(dir('.git'  ))
            self['scm'] = 'svn'   if File.directory?(dir('.svn'  ))
            self['scm'] = 'bzr'   if File.directory?(dir('.bzr'  ))
            self['scm'] = 'hg'    if File.directory?(dir('.hg'   ))
            self['scm'] = 'darcs' if File.directory?(dir('_darcs'))
            # detect TYPE
            typecount = {}
            Dir.chdir self.dir do
                typecount = {'ruby'       => Dir.glob('**/*.rb').reject{|i|i=~/^(_darcs|\.git|\.svn|\.bzr|\.hg)/}.count,
                             'python'     => Dir.glob('**/*.{py,pyc}').reject{|i|i=~/^(_darcs|\.git|\.svn|\.bzr|\.hg)/}.count,
                             'java'       => Dir.glob('**/*.{java,class}').reject{|i|i=~/^(_darcs|\.git|\.svn|\.bzr|\.hg)/}.count,
                             'javascript' => Dir.glob('**/*.js').reject{|i|i=~/^(_darcs|\.git|\.svn|\.bzr|\.hg)/}.count,
                             'pl'         => Dir.glob('**/*.pl').reject{|i|i=~/^(_darcs|\.git|\.svn|\.bzr|\.hg)/}.count,
                             'c'          => Dir.glob('**/*.c').reject{|i|i=~/^(_darcs|\.git|\.svn|\.bzr|\.hg)/}.count,
                             'cpp'        => Dir.glob('**/*.{cc,cpp,c++}').reject{|i|i=~/^(_darcs|\.git|\.svn|\.bzr|\.hg)/}.count,
                             'erl'        => Dir.glob('**/*.{erl,beam}').reject{|i|i=~/^(_darcs|\.git|\.svn|\.bzr|\.hg)/}.count
                            }
               typecount[nil] = Dir.glob(%w(**/*[^/] *[^/])).count - typecount.values.flatten.count
            end
            if eval(typecount.reject{|k,v|(k == nil) or (v == 0)}.values.join('+'))
                self['type'] = nil
            else
                self['type'] = typecount.sort{|a1,a2| a1[1] <=> a2[1]}.first[0]
            end
            # detect SYNC
            case self['scm']
                when 'git'
                    self['fetch'] = Dir.chdir(dir) { `git remote`.split("\n").first }
                when 'svn'
                    self['do_update'] = true
                when 'bzr'
                    self['do_update'] = Dir.chdir(dir) { `bzr info`.scan(/^\s*checkout of branch:/i).size > 0 }
                when 'hg'
                    self['do_pull'] = Dir.chdir(dir) { `hg showconfig paths.default`.size > 0 }
                when 'darcs'
                    self['do_pull'] = Dir.chdir(dir) { `darcs show repo`.scan(/^\s*Default Remote/i).size > 0 }
            end
            self
        end
    end
end

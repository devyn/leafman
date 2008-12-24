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
      erb   = 0
      rb    = 0
      py    = 0
      java  = 0
      js    = 0
      pl    = 0
      c     = 0
      cpp   = 0
      other = 0
      
      goproc = proc do |d|
        (Dir.entries(d) - %w(. .. .git .svn .bzr .hg _darcs)).each do |e|
          if File.file?(File.join(d, e))
            case e.split('.').last.downcase
              when 'erb'
                erb   += 1
              when 'rb'
                rb    += 1
              when 'py'
                py    += 1
              when 'java'
                java  += 1
              when 'js'
                js    += 1
              when 'pl'
                pl    += 1
              when 'c', 'h'
                c     += 1
              when 'cc', 'hh', 'cpp', 'hpp', 'c++', 'h++'
                cpp   += 1
              else
                other += 1
            end
          else
            goproc.call File.join(d, e)
          end
        end
      end
      goproc.call dir
      self['type'] = {'rails' => erb, 'ruby' => rb, 'python' => py, 'java' => java, 'javascript' => js, 'perl' => pl, 'c' => c, 'c++' => cpp, nil => other}.sort{|a1,a2|a2[1] <=> a1[1]}.first[0]
      # detect SYNC.
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

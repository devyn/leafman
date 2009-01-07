# Leafman Interactive Shell
require 'readline'
module Leafman
  class Shell
    def initialize
      @current_project = Leafman::Projects.find '@@'
      @running = false
    end
    def running?
      @running
    end
    def start
      @running = true
      # other start code...
    end
    def stop
      @running = false
      # other stop  code...
    end
    def run_input
      cp_color_code = ""
      Leafman.print "#{cp_color_code}#{@current_project ? @current_project.scm_color + @current_project['name'] : nil}\e[0m \e[1m>>\e[0m "
      line = Readline.readline
      return if !line or line.empty?
      Readline::HISTORY.push line
      sso = autosplit line
      sso.each do |ss|
        case ss[0]
        when 'chproj'
          @current_project = Leafman::Projects.find ss[1]
        when 'exit', 'quit'
          stop
        else
          if @current_project
            Dir.chdir(@current_project.dir) { Leafman.parse_args *ss }
          else
            Dir.chdir(File.expand_path(Leafman::PROJECT_DIR)) { Leafman.parse_args *ss }
          end
        end
      end
    end
    def autosplit input
      fst = input.split(" ")
      snd = []
      trd = []
      qad = [[]]
      inr = false
      fst.each do |pt|
        if pt =~ /^"[^ "]*"$/
          snd << pt.sub(/^"/, '').sub(/"$/, '')
        elsif pt =~ /^"/
          snd << pt.sub(/^"/, '')
          inr = true
        elsif (pt =~ /"$/) and inr
          snd[-1] << " #{pt.sub(/"$/, '')}"
          inr = false
        elsif inr
          snd[-1] << " #{pt}"
        else
          snd << pt
        end
      end
      snd.each do |pt|
        if pt =~ /^'[^ ']*'$/
          snd << pt.sub(/^'/, '').sub(/'$/, '')
        elsif pt =~ /^'/
          trd << pt.sub(/^'/, '')
          inr = true
        elsif (pt =~ /'$/) and inr
          trd[-1] << " #{pt.sub(/'$/, '')}"
          inr = false
        elsif inr
          trd[-1] << " #{pt}"
        else
          trd << pt
        end
      end
      trd.each do |pt|
        if pt == "&"
          qad << []
        else
          qad[-1] << pt
        end
      end
      qad
    end
  end
end

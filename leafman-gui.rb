#!/usr/bin/env shoes
# Run with shoes.

Shoes.setup do
    gem 'hpricot'
    gem 'mechanize'
    gem 'highline'
end

require 'leafman'

class LeafmanGUI < Shoes
    url '/', :index
    url '/sync', :sync
    def layout(where)
        background lime..black
        title link("Leafman", :click => '/', :stroke => black)
        subtitle where, :emphasis => 'italic'
        para "\n"
    end
    def index
        layout %|main|
        stack(:top => 0.4, :left => 0.4, :width => 0.2, :height => 0.2) do
            background rgb(255,255,255,0.5)
            para '- ', link('Sync', :click => '/sync', :stroke => green)
        end
    end
    def sync
        layout %|sync|
        @syncStack = stack(:top => 0.2, :left => 0.2, :width => 0.6, :height => 0.6) do
            background rgb(0,0,0,0.5)
            button "Start syncing!", :top => 0.45, :left => 0.3, :width => 0.4, :height => 0.1 do
                @syncStack.clear do
                    background rgb(255,255,255,0.5)
                    caption "Syncing all projects...", :emphasis => 'italic'
                    @cp = title "None", :weight => 'bold', :align => 'center'
                    @cc = para "Starting Sync...", :font => 'monospace', :align => 'center'
                    @pg = progress :width => 1.0, :height => 0.1
                    flow(:bottom => 0, :width => 1.0, :height => 0.1) {background black; @cbx = para "Starting Sync...", :font => 'monospace', :stroke => white}
                    cnt = Leafman::Projects.count.to_f
                    Thread.start do
                        Leafman::Projects.each_with_index do |p,ind|
                            @cp.replace p['name']
                            @pg.fraction = ind / cnt
                            @cbx.replace "Syncing #{p['name']}..."
                            ep = proc do |cmd|
                                IO.popen(cmd) do |pr|
                                    pr.each_line do |l|
                                        @cbx.replace l
                                    end
                                end
                            end
                            # sy exec
                            case
                            when (p['scm']=='git') && p['fetch']
                                Dir.chdir(p.dir) do
                                    @cc.replace "git pull #{p['fetch']} master"
                                    ep.call "git pull #{p['fetch']} master"
                                end
                            when (p['scm']=='svn') && p['do_update']
                                Dir.chdir(p.dir) do
                                    @cc.replace "svn up"
                                    ep.call "svn up"
                                end
                            when (p['scm']=='bzr') && p['do_update']
                                Dir.chdir(p.dir) do
                                    @cc.replace "bzr up"
                                    ep.call "bzr up"
                                end
                            when (p['scm']=='hg') && p['do_pull']
                                Dir.chdir(p.dir) do
                                    @cc.replace "hg pull -u"
                                    ep.call "hg pull -u"
                                end
                            when (p['scm']=='darcs') && p['do_pull']
                                Dir.chdir(p.dir) do
                                    @cc.replace "darcs pull -a"
                                    ep.call "darcs pull -a"
                                end
                            # synkage not implemented yet
                            else
                                next
                            end
                        end
                        @cp.replace ""
                        @cc.replace "Done!"
                        @cbx.replace ""
                        @pg.fraction = 1.0
                    end
                end
            end
        end
    end
end

Shoes.app :title => "Leafman", :width => 640, :height => 480

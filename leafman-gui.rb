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
    url '/sync/(.+)', :sync
    url '/list', :list
    url '/show/(.+)', :show
    url '/edit/(.+)', :edit
    url '/destroy/(.+)', :destroy
    url '/initSCM/(.+)', :initSCM
    url '/taskManager/(.+)', :taskManager
    def layout(where)
        background lime..black
        title link("Leafman", :click => '/', :stroke => black)
        subtitle where, :emphasis => 'italic'
        para "\n"
    end
    def index
        layout %|main|
        stack(:top => 0.3, :left => 0.3, :width => 0.4, :height => 0.4) do
            background rgb(255,255,255,0.5)
            border rgb(0,0,0,0.5)..rgb(140,140,140,0.5), :strokewidth => 4, :angle => 45
            caption '- ', link('List', :click => '/list', :stroke => green)
            caption '- ', link('Sync', :click => '/sync', :stroke => green)
            flow { caption '-'; @el_create = edit_line :width => 0.4; caption link('Create', :click => proc { pname = @el_create.text; FileUtils.mkdir_p(File.join(File.expand_path(Leafman::PROJECT_DIR), pname)); Leafman::Projects.add(pname, 'scm' => nil, 'type' => nil); visit "/show/#{URI.escape(pname)}" }, :stroke => green) }
        end
    end
    def sync(select=nil)
        layout %|sync|
        @syncStack = stack(:top => 0.2, :left => 0.2, :width => 0.6, :height => 0.6) do
            background rgb(0,0,0,0.5)
            border rgb(255,255,255,0.5)..rgb(116,116,116,0.5), :strokewidth => 4, :angle => 45
            button "Start syncing!", :top => 0.45, :left => 0.3, :width => 0.4, :height => 0.1 do
                @syncStack.clear do
                    background rgb(255,255,255,0.5)
                    border rgb(0,0,0,0.5)..rgb(140,140,140,0.5), :strokewidth => 4, :angle => 45
                    caption "Syncing #{select ? URI.unescape(select) : 'all projects'}...", :emphasis => 'italic'
                    @cp = title "None", :weight => 'bold', :align => 'center'
                    @cc = para "Starting Sync...", :font => 'monospace', :align => 'center'
                    @pg = progress :width => 1.0, :height => 0.1
                    flow(:bottom => 0, :width => 1.0, :height => 0.1) {background black; @cbx = para "Starting Sync...", :font => 'monospace', :stroke => white}
                    cnt = Leafman::Projects.count.to_f
                    @abb = button "Abort", :right => 0, :top => 0 do
                        @kt.kill
                        visit '/'
                    end
                    @kt = Thread.start do
                        Leafman::Projects.each_with_index(*(select ? [URI.unescape(select)] : [])) do |p,ind|
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
                        @abb.hide
                    end
                end
            end
        end
    end
    def list
        layout %|list|
        flow :width => 1.0, :height => 0.8, :bottom => 0, :left => 0, :scroll => true do
            background rgb(0,0,0,0.5)
            Leafman::Projects.each do |p|
                fetchable = nil
                case p['scm']
                when 'git'
                    fetchable = p['fetch']
                when 'svn','bzr'
                    fetchable = p['do_update']
                when 'hg','darcs'
                    fetchable = p['do_pull']
                else
                    fetchable = false
                end
                pushable = p['do_push']
                image 25,25 do
                    stroke black
                    if pushable and fetchable
                        fill yellow
                    elsif pushable
                        fill red
                    elsif fetchable
                        fill lime
                    else
                        fill white
                    end
                    oval(7,7,15)
                end
                caption link(p['name'], :click => "/show/#{URI.escape(p['name'])}", :stroke => rgb(*p.scm_color_shoes)), "\n"
            end
        end
    end
    def show(select)
        layout %|show|
        p = Leafman::Projects.find(URI.unescape(select))
        stack :width => 0.5, :height => 0.5, :left => 0.25, :top => 0.25, :scroll => true do
            background rgb(0,0,0,0.5)
            border rgb(255,255,255,0.5)..rgb(116,116,116,0.5), :strokewidth => 4, :angle => 45
            stack(:width => 0.9, :left => 4, :top => 4) do
                para " " # divider
                subtitle p['name'], :stroke => rgb(*p.scm_color_shoes)
                flow :right => 0, :top => 0 do
                    case p['scm']
                    when 'git'
                        para link("sync", :stroke => orange, :click => "/sync/#{select}"), :align => 'right' if p['fetch']
                    when 'svn','bzr'
                        para link("sync", :stroke => orange, :click => "/sync/#{select}"), :align => 'right' if p['do_update']
                    when 'hg','darcs'
                        para link("sync", :stroke => orange, :click => "/sync/#{select}"), :align => 'right' if p['do_pull']
                    else
                        para link("sync", :stroke => orange, :click => "/sync/#{select}"), :align => 'right' if p['synkage_url']
                    end
                    if p['scm']
                        #para link("push", :stroke => orange, :click => "/push/#{select}"), :align => 'right' if p['do_push']
                        #para link("commit", :stroke => orange, :click => "/commit/#{select}"), :align => 'right'
                    end
                    para link("edit", :stroke => orange, :click => "/edit/#{select}"), :align => 'right'
                    para link("destroy", :stroke => orange, :click => proc { visit "/destroy/#{select}" if confirm("Are you sure? This will remove all the project's files too!") }), :align => 'right'
                    para link("task manager", :stroke => orange, :click => "/taskManager/#{select}"), :align => 'right'
                end
                if d = p['description']
                    inscription d, :emphasis => 'italic', :stroke => yellow
                end
            end
        end
    end
    def edit(select)
        layout %|edit|
        p = Leafman::Projects.find(URI.unescape(select))
        stack(:width => 1.0, :height => 0.8, :bottom => 0, :left => 0, :scroll => true) do
            background rgb(0,0,0,0.5)
            title p['name'], :stroke => rgb(*p.scm_color_shoes)
            flow do
                para strong("SCM: "), :stroke => white
                if p['scm']
                    para em(p.full_scm_name), :stroke => rgb(*p.scm_color_shoes)
                else
                    para em("None "), link("change", :stroke => orange, :click => "/initSCM/#{select}"), :stroke => rgb(*p.scm_color_shoes)
                end
            end
            flow :height => 0.2 do
                para strong("Description: "), :stroke => white
                edit_box p['description']||"", :width => 0.5, :height => 1.0 do |box|
                    p['description'] = box.text
                end
            end
            flow do
                para strong("Type: "), :stroke => white
                if p['type']
                    para em(p['type']), :stroke => white
                    #para link("redetect", :stroke => orange, :click => proc { p.detect; alert "Redetection complete. Type decided: #{p['type']}"; visit "/show/#{select}" })
                else
                    para em("None"), :stroke => white
                    #para link("detect", :stroke => orange, :click => proc { p.detect; alert "Redetection complete. Type decided: #{p['type']}"; visit "/show/#{select}" })
                end
            end
            flow do
                para link("visit task manager", :stroke => orange, :click => "/taskManager/#{select}")
            end
            button "Back", :right => 0, :bottom => 0 do
                visit "/show/#{select}"
            end
        end
    end
    def destroy(select)
        layout %|destroy|
        p = Leafman::Projects.find(URI.unescape(select))
        flow(:top => 0.3) { subtitle "Destroying project #{p['name']}", :emphasis => 'italic' }
        Thread.start do
            sleep 0.5
            FileUtils.rm_rf p.dir
            FileUtils.rm p.conf_file_path
            visit '/'
        end
    end
    def initSCM(select)
        layout %|initialize SCM|
        p = Leafman::Projects.find(URI.unescape(select))
        init = proc do |gsbhd|
            Dir.chdir(p.dir) do
                successful = true
                case gsbhd
                when 'git'
                    system 'git init' or (alert("failed to initialize."); successful = false)
                when 'bzr'
                    system 'bzr init' or (alert("failed to initialize."); successful = false)
                when 'hg'
                    system 'hg init' or (alert("failed to initialize."); successful = false)
                when 'darcs'
                    system 'darcs initialize' or (alert("failed to initialize."); successful = false)
                end
                p['scm'] = gsbhd if successful
                visit "/show/#{select}"
            end
        end
        stack(:height => 0.5, :width => 0.5, :top => 0.25, :left => 0.25) do
            para "Select an SCM"
            caption link("Git", :stroke => rgb(0, 140, 0), :click => proc{init.call('git')})
            caption link("Bazaar", :stroke => rgb(140, 140, 0), :click => proc{init.call('bzr')})
            caption link("Mercurial", :stroke => rgb(0, 140, 140), :click => proc{init.call('hg')})
            caption link("Darcs", :stroke => rgb(140, 0, 140), :click => proc{init.call('darcs')})
        end
    end
    def taskManager(select)
        layout %|task manager|
        p = Leafman::Projects.find(URI.unescape(select))
        stack(:width => 1.0, :height => 0.8, :bottom => 0, :left => 0, :scroll => true) do
            background rgb(0,0,0,0.5)
            flow { subtitle "Tasks", :stroke => cyan; caption link("add", :stroke => white, :click => proc { t = ask("What shall this task be?"); p['todos'] ||= []; p['todos'] += [t]; visit "/taskManager/#{select}" }) }
            p['todos'].each_with_index do |td,ind|
                flow { inscription td, "    ", link('complete', :stroke => black, :click => proc { (tds = p['todos']).delete_at ind; p['todos'] = tds; visit "/taskManager/#{select}" }), :stroke => yellow }
            end if p['todos']
            flow { subtitle "Bugs", :stroke => cyan; caption link("add", :stroke => white, :click => proc { b = ask("What shall this bug be?"); p['bugs'] ||= []; p['bugs'] += [b]; visit "/taskManager/#{select}" }) }
            p['bugs'].each_with_index do |td,ind|
                flow { inscription td, "    ", link('complete', :stroke => black, :click => proc { (bgs = p['bugs']).delete_at ind; p['bugs'] = bgs; visit "/taskManager/#{select}" }), :stroke => red }
            end if p['bugs']
            button "Back", :bottom => 0, :right => 0 do
                visit "/show/#{select}"
            end
        end
    end
end

Shoes.app :title => "Leafman", :width => 640, :height => 480

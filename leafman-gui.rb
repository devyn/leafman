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
    end
end

Shoes.app :title => "Leafman", :width => 640, :height => 480

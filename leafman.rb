#!/usr/bin/env ruby
# Leafman M2, the LEAF way to get stuff done!
module Leafman
    extend self
    attr :config
    VERSION = "m3"
end
require 'yaml'
require 'fileutils'
require 'rubygems' rescue nil
require File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'extensions')
require File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'projects')
require File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'configs')
require File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'servlet')
Dir.glob(File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'commands', '*.rb')).sort.each do |cf|
    load cf
end
load '.leafman-rc' if File.exists?('.leafman-rc')
load File.join(File.expand_path(Leafman::PROJECT_DIR), ".leafman-rc") if File.exists?(File.join(File.expand_path(Leafman::PROJECT_DIR), ".leafman-rc"))
if __FILE__ == $0
    Leafman.parse_args *ARGV
end


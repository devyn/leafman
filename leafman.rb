#!/usr/bin/env ruby
# Leafman, the LEAF way to get stuff done!
module Leafman
    extend self
    attr :config
    VERSION = "vuhu m5"
end
$: << File.dirname(File.expand_path(__FILE__))
require 'yaml'
require 'fileutils'
require 'rubygems' rescue nil
require 'lib/extensions'
require 'lib/projects'
require 'lib/configs'
require 'lib/servlet'
require 'lib/detection'
require 'lib/shell'
require 'lib/pretty'
Dir.glob(File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'commands', '*.rb')).sort.each do |cf|
    load cf
end
load '.leafman-rc' if File.exists?('.leafman-rc')
load File.join(File.expand_path(Leafman::PROJECT_DIR), ".leafman", "_commands") if File.exists?(File.join(File.expand_path(Leafman::PROJECT_DIR), ".leafman", "_commands"))
if __FILE__ == $0
    Leafman.parse_args *ARGV
end


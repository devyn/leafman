#!/usr/bin/env ruby
# Leafman M2, the LEAF way to get stuff done!
module Leafman
    extend self
end
require 'yaml'
require 'fileutils'
require File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'extensions')
require File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'projects')
require File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'configs')
Dir.glob(File.join(File.dirname(File.expand_path(__FILE__)), 'lib', 'commands', '*.rb')).sort.each do |cf|
    load cf
end
load '.leafman-rc' if File.exists?('.leafman-rc')
if __FILE__ == $0
    Leafman.parse_args *ARGV
end


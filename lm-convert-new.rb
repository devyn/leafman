#!/usr/bin/env ruby
# Leafman converter from in-project-dir configs to one-dir configs
base_dir = File.expand_path(ENV['LEAFMAN_DIR']||"~/Projects")
puts "moving config file"
File.rename File.join(base_dir, '.leafman'), File.join(base_dir, '.leafman-conf')
Dir.mkdir File.join(base_dir, '.leafman')
File.rename File.join(base_dir, '.leafman-conf'), File.join(base_dir, '.leafman', '_config')
puts "moving commands file"
File.rename File.join(base_dir, '.leafman-rc'), File.join(base_dir, '.leafman', '_commands')
Dir.glob(File.join(base_dir, '*', '.leafman-project')).each do |f|
    puts "processing #{File.basename(File.dirname(f))}"
    File.rename f, File.join(base_dir, '.leafman', "#{File.basename(File.dirname(f))}.yml")
end

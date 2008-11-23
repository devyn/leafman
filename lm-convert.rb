# lm-convert: convert old database format to the new one
require 'yaml'
abort "Usage: #{$0} <leafman-project-dir>" unless ARGV.size == 1
y = YAML.load(File.read(File.join(File.expand_path(ARGV[0]), ".leafman")))
File.open(File.join(File.expand_path(ARGV[0]), ".leafman"), 'w') do |f|
    puts 'processing config'
    f.write YAML.dump(y['config']) # convert the .leafman file into a config file
end
y['projects'].each do |p|
    File.open(File.join(File.expand_path(ARGV[0]), p['name'], ".leafman-project"), 'w') do |f|
        puts "processing #{p.delete 'name'}"
        f.write YAML.dump(p) # write the new DB format
    end
end
puts "done!"

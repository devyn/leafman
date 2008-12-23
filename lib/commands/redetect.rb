Leafman::Command.new "redetect", "[project-names...]", "redetect information about a project based on its contents" do |*projs|
  include Leafman::Mixin
  Leafman::Projects.each(*projs) do |p|
    puts "processing #{p['name']}."
    p.detect
  end
  puts "\e[1m\e[32mdone!\e[0m"
end

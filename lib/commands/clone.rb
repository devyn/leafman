Leafman::Command.new "clone", "<project-name> [host[:port]]", "clones a project from the leafman web interface into your database" do |pname, *a|
    include Leafman::Mixin
    puts "\e[1mclone:\e[0m #{pname} \e[1mat:\e[0m #{a[0] or 'localhost'}"
    Leafman::Cloneable.auto_clone pname, *(a[0] or 'localhost').split(":")
    puts "\e[1m\e[32mdone!\e[0m"
end

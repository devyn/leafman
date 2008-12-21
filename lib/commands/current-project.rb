# display the project name in the pwd
Leafman::Command.new "current-project", "", "prints the current project name in the working directory", "shell assistants" do
    include Leafman::Mixin
    next unless pr = Dir.pwd.scan(/^#{Regexp.escape(File.expand_path(Leafman::PROJECT_DIR))}\/([^\/]+)/).flatten.first
    puts pr
end

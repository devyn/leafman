# display the project name in the pwd
Leafman::Command.new "current-project", "", "prints the current project name in the working directory", "shell assistants" do
    include Leafman::Mixin
    puts Leafman::Projects.current
end

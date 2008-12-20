Leafman::Command.new "skel-rails", "<project-name> [rails-options...]", "run 'rails' on the <project-name>'s dir with [rails-options...]" do |pname, *rails_opts|
    include Leafman::Mixin
    puts "\e[1mskel-rails:\e[0m #{pname}"
    p = Leafman::Projects.find(pname)
    warn("\e[31m\e[1mproject not found.\e[0m")||true&&next unless p
    puts "\e[1mrun \e[0m'rails'\e[1m on project dir\e[0m"
    Dir.chdir(File.join(File.expand_path(Leafman::PROJECT_DIR), pname)) do
        run = ["rails"]
        run += rails_opts
        run << "."
        system *run
    end
    puts "\e[1mchange type to\e[0m rails"
    p['type'] = 'rails'
    puts "\e[32m\e[1mdone!\e[0m"
end

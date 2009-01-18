Leafman::Command.new "skel-rails", "<project-name> [rails-options...]", "run 'rails' on the <project-name>'s dir with [rails-options...]" do |pname, *rails_opts|
    include Leafman::Mixin
    title "skel-rails: #{pname}"
    p = Leafman::Projects.find(pname)
    error("project not found.")||true&&next unless p
    command "chdir \"#{p.dir}\""
    Dir.chdir(p.dir) do
        run = ["rails"]
        run += rails_opts
        run << "."
        command run.join(' ')
        system *run
    end
    task "change type to rails"
    p['type'] = 'rails'
    finished
end

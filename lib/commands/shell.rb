Leafman::Command.new "shell", "", "starts an interactive shell" do
  include Leafman::Mixin
  sh = Leafman::Shell.new
  sh.start
  while sh.running?
    sh.run_input
  end
end

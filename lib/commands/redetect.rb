Leafman::Command.new "redetect", "[project-names...]", "redetect information about a project based on its contents" do |*projs|
  include Leafman::Mixin
  task 'redetect project information'
  Leafman::Projects.each(*projs) do |p|
    log "processing #{p['name']}."
    p.detect
  end
  finished
end

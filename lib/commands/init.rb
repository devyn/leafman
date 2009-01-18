Leafman::Command.new "init", "", "initialize the project directories for first time" do
    include Leafman::Mixin
    epath = File.expand_path Leafman::PROJECT_DIR
    title "init: #{epath}"
    error("#{File.join(epath, '.leafman')}: dir already exists. refusing to init.")||true&&exit(1) if File.directory?(File.join(epath, '.leafman'))
    FileUtils.mkdir_p File.join(epath, '.leafman'), :verbose => true
    task "config skeleton"
    @config = {}
    finished
end

Leafman::Command.new "init", "", "initialize the project directories for first time" do
    include Leafman::Mixin
    epath = File.expand_path Leafman::PROJECT_DIR
    puts "\e[1minit:\e[0m #{epath}"
    abort("#{File.join(epath, '.leafman')}: \e[31m\e[1mdir already exists. refusing to init.\e[0m") if File.directory?(File.join(epath, '.leafman'))
    FileUtils.mkdir_p File.join(epath, '.leafman'), :verbose => true
    puts "\e[1mconfig skeleton\e[0m"
    @config = {}
    puts "\e[32m\e[1mdone!\e[0m"
end

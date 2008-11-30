require 'webrick'
Leafman::Command.new "serve", "", "set up an HTTPServer for all projects" do
    puts "\e[1mstarting server...\e[0m"
    serv = WEBrick::HTTPServer.new(:Port => 8585)
    serv.mount("/", Leafman::Servlet)
    trap("INT")  {serv.shutdown}
    trap("TERM") {serv.shutdown}
    serv.start
end

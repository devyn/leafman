require 'webrick'
Leafman::Command.new "serve", "[port]", "set up an HTTPServer for all projects (optionally, on [port] or 8585)" do |*args|
    puts "\e[1mstarting server...\e[0m"
    serv = WEBrick::HTTPServer.new(:Port => (args.shift or 8585))
    serv.mount("/", Leafman::Servlet)
    trap("INT")  {serv.shutdown}
    trap("TERM") {serv.shutdown}
    serv.start
end

### ADD-ON (github-auto-fork) BEGIN ###
# GitHub auto fork for Leafman, using WWW::Mechanize
require 'mechanize'
Leafman::Command.new 'github-auto-fork', '<user>/<repo>', 'automatic github repo forking', 'official addons' do |user_and_repo|
  include Leafman::Mixin
  puts "\e[1mgithub-auto-fork\e[0m"
  agent = WWW::Mechanize.new
  agent.user_agent_alias = 'Linux Mozilla' # just a hack to get this to work
  puts "\e[1mconnecting to GitHub\e[0m"
  main_page = agent.get 'http://github.com/'
  puts "\e[1mfetching the login page\e[0m"
  login_page = main_page.links.select{|l|l.text=~/^login$/i}.first.click
  login_form = login_page.forms.first
  puts "Don't worry, this information doesn't go anywhere."
  print "Your GitHub username? "
  me = $stdin.readline.chomp; login_form['login'] = me
  print "Your GitHub password? "
  login_form['password'] = $stdin.readline.chomp
  puts "\e[1mlogging in...\e[0m"
  login_form.submit
  puts "\e[1mforking repo\e[0m"
  agent.get "/#{user_and_repo}/fork"
  puts "waiting 10 seconds to be sure that repo is forked..."
  sleep 10
  puts "\e[1mcloning fork\e[0m"
  system 'git', 'clone', "git@github.com:#{me}/#{user_and_repo.split('/').last}.git", File.join(File.expand_path(Leafman::PROJECT_DIR), user_and_repo.split('/').last)
  Dir.chdir(File.join(File.expand_path(Leafman::PROJECT_DIR), user_and_repo.split('/').last)) { system 'git', 'remote', 'add', 'forked_from', "git://github.com/#{user_and_repo}.git" }
  puts "\e[1madding project to database\e[0m"
  Leafman::Projects.add user_and_repo.split('/').last, 'scm' => 'git', 'type' => nil, 'fetch' => 'forked_from', 'do_push' => true
  puts "\e[1m\e[32mdone!\e[0m"
end
### ADD-ON (github-auto-fork) END   ###

### ADD-ON (github-auto-fork) BEGIN ###
# GitHub auto fork for Leafman, using WWW::Mechanize, and HighLine for asking questions and stuff.
require 'mechanize'
require 'highline'
class << $stdin
  def eof?
    false
  end
end
Leafman::Command.new 'github-auto-fork', '<user>/<repo>', 'automatic github repo forking', 'official addons' do |user_and_repo|
  include Leafman::Mixin
  title "github-auto-fork"
  agent = WWW::Mechanize.new
  agent.user_agent_alias = 'Linux Mozilla' # just a hack to get this to work
  task "connecting to GitHub"
  main_page = agent.get 'http://github.com/'
  task "fetching the login page"
  login_page = main_page.links.select{|l|l.text=~/^login$/i}.first.click
  login_form = login_page.forms.first
  puts "Don't worry, this information doesn't go anywhere."
  me = $terminal.ask('Your GitHub username? '); login_form['login'] = me
  login_form['password'] = $terminal.ask('Your GitHub password? ') {|q| q.echo = '*' }
  task "logging in"
  login_form.submit
  task "forking repo"
  agent.get "/#{user_and_repo}/fork"
  log "waiting 15 seconds to be sure that repo is forked..."
  sleep 15
  task "cloning fork"
  command 'git clone ...'
  system 'git', 'clone', "git@github.com:#{me}/#{user_and_repo.split('/').last}.git", File.join(File.expand_path(Leafman::PROJECT_DIR), user_and_repo.split('/').last)
  command 'git remote add ...'
  Dir.chdir(File.join(File.expand_path(Leafman::PROJECT_DIR), user_and_repo.split('/').last)) { system 'git', 'remote', 'add', 'forked_from', "git://github.com/#{user_and_repo}.git" }
  task "adding project to database"
  Leafman::Projects.add user_and_repo.split('/').last, 'scm' => 'git', 'type' => nil, 'fetch' => 'forked_from', 'do_push' => true
  finished
end
### ADD-ON (github-auto-fork) END   ###

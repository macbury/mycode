set :application, "mycode"

set :use_sudo, false

set :scm, :git

set :scm_verbose, true
set :deploy_via, :remote_cache
set :copy_exclude, %w(.git)
set :git_shallow_clone, 1
	 
set :repository, "ssh://tomekzi@tomekzi.megiteam.pl/home/tomekzi/www/git/benefi.git"
set :scm_username, "tomekzi"
set :scm_password, "bene99"

set :user, "mycode"
set :deploy_to, "/home/mycode/www/#{application}"
set :rails_env, "production"

role :app, "mycode.megiteam.pl"
role :web, "mycode.megiteam.pl"
role :db,  "mycode.megiteam.pl", :primary => true

namespace :deploy do
  desc "Restart aplikacji przy pomocy skryptu Megiteam"
  task :restart, :role => :app do
    run "restart-app #{ application }"
  end
end
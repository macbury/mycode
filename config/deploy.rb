set :application, "mycode"

set :repository, "." 
set :scm, :none 
set :deploy_via, :copy

set :use_sudo, false

set :deploy_to, "/home/mycode/www/#{application}"
set :rails_env, "production"


role :app, "mycode.megiteam.pl"
role :web, "mycode.megiteam.pl"
role :db,  "mycode.megiteam.pl", :primary => true
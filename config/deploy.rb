# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "on_money"
set :repo_url, "git@github.com:yashka713/on_money_back.git"

set :console_env, :production
set :console_role, :app

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/on_money"

set :deploy_user, "deployer"

set :rvm_map_bins, %w{gem rake ruby rails bundle}
set :rvm_custom_path, "/home/deployer/.rvm"

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

namespace :deploy do

  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  after :publishing, :restart
end

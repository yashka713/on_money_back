namespace :db do

  desc "Drop database"
  task :drop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rails db:drop DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
        end
      end
    end
  end

  desc "Create database"
  task :create do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rails db:create DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
        end
      end
    end
  end

  desc "Run migrations"
  task :migrate do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rails db:migrate DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
        end
      end
    end
  end

  desc "Reset database"
  task :reset do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rails db:drop db:create db:migrate DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
        end
      end
    end
  end

  desc "Seed database"
  task :seed do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rails db:seed DISABLE_DATABASE_ENVIRONMENT_CHECK=1"
        end
      end
    end
  end
end

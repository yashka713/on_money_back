require 'elasticsearch/rails/tasks/import'

namespace :elasticsearch do
  desc 'Reindex existing data for Transaction, Tag, Account, Category'
  task :reindex => :environment do
    # reindex Transaction
    sh "bundle exec rake environment elasticsearch:import:model CLASS='Transaction' FORCE=true"
    # reindex Tag
    sh "bundle exec rake environment elasticsearch:import:model CLASS='Tag' FORCE=true"
    # reindex Account
    sh "bundle exec rake environment elasticsearch:import:model CLASS='Account' FORCE=true"
    # reindex Category
    sh "bundle exec rake environment elasticsearch:import:model CLASS='Category' FORCE=true"
  end
end

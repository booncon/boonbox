set :application, 'example_project'
set :repo_url, 'git@github.com:booncon/example_project.git'

# Hardcodes branch to always be master
# This could be overridden in a stage config file
set :branch, :master

set :deploy_to, "/var/www/#{fetch(:application)}"

set :log_level, :info

set :linked_dirs, %w{web/app/uploads}

namespace :uploads do
  desc "Pull the remote uploaded files"
  task :pull do
    on roles(:all) do |host|
      puts "Fetching the uploads from #{fetch(:stage)}"
      system("rsync -avzh #{fetch(:user)}@#{host}:#{fetch(:uploads_path)} #{File.expand_path File.dirname(__FILE__)}/../web/app/")
    end
  end
end

namespace :db do
  desc "Pull the remote database"
  task :pull do
    on roles(:web) do
      within release_path do
        with path: "#{fetch(:release_path)}vendor/wp-cli/wp-cli/bin:$PATH" do
          execute :wp, "db export example_project.sql --path=web/wp"
          download! "#{release_path}/example_project.sql", "example_project.sql"
          execute :rm, "#{release_path}/example_project.sql"
        end
      end
      run_locally do
        execute "mv example_project.sql ~/Downloads/"
      end
    end
  end
end
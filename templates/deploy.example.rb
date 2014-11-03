set :application, 'example-project'
set :repo_url, 'git@github.com:booncon/example-project.git'

# Hardcodes branch to always be master
# This could be overridden in a stage config file
set :branch, :master

set :deploy_to, "/var/www/#{fetch(:application)}"

set :log_level, :info

set :linked_dirs, %w{web/app/uploads}

set :stage_script, "/var/www/stage/home/current/web/scripts"

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
          execute :wp, "db export example-project.sql --path=web/wp"
          download! "#{release_path}/example-project.sql", "example-project.sql"
          execute :rm, "#{release_path}/example-project.sql"
        end
      end
      run_locally do
        execute "mv example-project.sql ~/Downloads/"
      end
    end
  end
  desc "Push the local database to remote"
  task :push do
    on roles(:web) do
      within release_path do
        with path: "#{fetch(:release_path)}vendor/wp-cli/wp-cli/bin:$PATH" do
          upload! "#{File.expand_path File.dirname(__FILE__)}/../example-project.sql", "#{release_path}/example-project.sql"
          execute :wp, "db import example-project.sql --path=web/wp"
          execute :rm, "#{release_path}/example-project.sql"
        end
      end
      run_locally do
        execute :rm, "example-project.sql"
      end
    end
  end
end

namespace :deploy do
  desc 'Setup a new project with files and db'
  task :setup do
    on roles(:web) do  
      if test "[ -d #{fetch(:deploy_to)} ]"
        error 'Sorry, this project already exists'
        exit 1
      end
    end
    dbpasw = ""
    invoke "#{scm}:check"
    invoke 'deploy:check:directories'
    invoke 'deploy:check:linked_dirs'
    invoke 'deploy:check:make_linked_dirs'
    invoke 'deploy:check:make_linked_files'
    invoke 'deploy'
    run_locally do
      dbpasw = capture "echo $(awk /DB_PASSWORD/ #{File.expand_path File.dirname(__FILE__)}/../.env)"
      dbpasw = dbpasw.split('=')[1]
      info "#{dbpasw}"
      execute :wp, "db export example-project.sql --path=web/wp"
    end
    invoke 'deploy:check:make_linked_files'
    on roles(:web) do
      info "#{dbpasw}"
      execute "#{fetch(:stage_script)}/db.sh #{fetch(:application)} #{dbpasw}"
      execute "#{fetch(:stage_script)}/npm.sh #{fetch(:application)}"
    end  
    invoke 'db:push'
  end

  namespace :check do
    desc 'Create the linked files'
    task :make_linked_files do
      next unless any? :linked_files
      on release_roles :all do |host|
        linked_files(shared_path).each do |file|
          if "#{file}".include? ".htaccess"
            upload! "#{File.expand_path File.dirname(__FILE__)}/../web/.htaccess", file
          end  
          if "#{file}".include? ".env"
            upload! "#{File.expand_path File.dirname(__FILE__)}/../.env", file
            execute :sed, "'s/development/staging/g' #{file} > /tmp/.env-tmp"
            execute :mv, "/tmp/.env-tmp #{file}"
            execute :sed, "'s/.dev/.stage.bcon.io/g' #{file} > /tmp/.env-tmp"
            execute :mv, "/tmp/.env-tmp #{file}"
            execute :sed, "'s/127.0.0.1/localhost/g' #{file} > /tmp/.env-tmp"
            execute :mv, "/tmp/.env-tmp #{file}" 
          end
        end
      end
    end
  end
end
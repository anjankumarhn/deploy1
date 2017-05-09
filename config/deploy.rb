# config valid only for current version of Capistrano

set :application, 'deploy1'
set :repo_url, 'git@github.com:anjankumarhn/deploy1.git'

set :format, :pretty

set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :linked_files, %w{config/database.yml}

set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }

set :keep_releases, 5

set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_dir, -> { shared_path.join('bundle') }
set :bundle_flags, '--deployment --quiet'
set :bundle_without, %w{development test}.join(' ')
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_roles, :all
set :bundle_bins, %w(gem rake rails)
set :whenever_roles, :all

# set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :deploy_via,      :remote_cache
set :puma_env, fetch(:rack_env, fetch(:rails_env))

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end

  before :start, :make_dirs
end

desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      invoke 'puma:restart'
      execute :touch, release_path.join('tmp/restart.txt')
      puts "RESTARTED SUCCESSFULLY"
    end
  end

desc 'Initial Deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end
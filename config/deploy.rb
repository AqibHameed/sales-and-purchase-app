# config valid only for current version of Capistrano
lock "3.11.0"

set :application, "idt"
set :repo_url, "git@bitbucket.org:IDTONLINE/idt.git"
set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_dirs, %w{log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

set :puma_threads,    [4, 16]

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/var/www/idt"

set :pty,             true
set :use_sudo,        false


# Default value for :format is :pretty
set :format, :pretty
set :keep_releases, 3

namespace :puma do
  desc 'Create Directories for Puma Pids and Socket'
  task :make_dirs do
    on roles(:app) do
      execute "mkdir #{shared_path}/tmp/sockets -p"
      execute "mkdir #{shared_path}/tmp/pids -p"
    end
  end
end

namespace :deploy do
  task :start do
    invoke 'puma:stop'
  end
  after  :finishing,    :start
end



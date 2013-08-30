require 'capistrano_colors'
require "bundler/capistrano"

# cap deploy時に自動で bundle install が実行される
require "bundler/capistrano"
set :bundle_flags, "--no-deployment --without test development"

# RVM
#$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system #:user

set :application, "thumbnails"
set :rails_env, "production"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`
set :scm, :git
set :repository,  "."
set :deploy_via, :copy
set :branch, "master"
set :deploy_to, "/var/www/#{application}"

# SSHの設定
set :user, "wmaster"
set :use_sudo, false
ssh_options[:forward_agent] = true
default_run_options[:pty] = true
set :default_environment, {
  'QMAKE' => '/opt/rh/qt48/root/usr/lib64/qt4/bin/qmake'
}

# Roles
role :web, "thumbnails.buripig.jp"                          # Your HTTP server, Apache/etc
role :app, "thumbnails.buripig.jp"                          # This may be the same as your `Web` server
role :db,  "thumbnails.buripig.jp", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

namespace :setup do
  # cap deploy:setup 後、/var/www/ の権限変更
  task :fix_permissions do
    sudo "chown -R #{user}:#{user} #{deploy_to}"
  end
end
after "deploy:setup", "setup:fix_permissions"

namespace :deploy do
  # Passenger用に起動/停止タスクを変更
  task :restart, :roles => :web do
    run "cp -p ~/secret/thumbnails/newrelic.yml #{current_path}/config/"
    run "touch #{current_path}/tmp/restart.txt"
    run "wget -O- http://thumbnails.buripig.jp/ > /dev/null"
    run "RAILS_ENV=production #{current_path}/script/delayed_job -n 2 -m --sleep-delay 1 --read-ahead 1 restart"
  end
end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# assets:precompile
# namespace :assets do
#   task :precompile, :roles => :web do
#     run "cd #{current_path} && RAILS_ENV=production bundle exec rake assets:precompile"
#   end
#   task :cleanup, :roles => :web do
#     run "cd #{current_path} && RAILS_ENV=production bundle exec rake assets:clean"
#   end
# end
# after :deploy, "assets:precompile"

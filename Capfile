# Load DSL and set up stages
require "capistrano/setup"
# Include default deployment tasks
require "capistrano/deploy"

# This will add tasks to your deploy process
require "capistrano/rails"
require "capistrano/rbenv"
#require "capistrano/yarn"
require "capistrano/bundler"
require 'capistrano/puma'


# If you are using rbenv add these lines:
set :rbenv_type, :user
set :rbenv_ruby, "2.3.1"

# Load the SCM plugin appropriate to your project:
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each {|r| import r}
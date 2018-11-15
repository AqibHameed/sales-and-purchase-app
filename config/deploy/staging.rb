set :stage, :production
set :rails_env, :staging
set :branch, "staging"

server "159.89.173.172", user: "deploy", password: "Dialuck@123", roles: %w{app db web}
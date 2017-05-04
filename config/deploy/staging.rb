set :stage, :staging
set :unicorn_rack_env, 'staging'
set :branch, :development
set :deploy_to, '/u01/apps/sigma/deploy1/'
set :log_level, :debug

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
role :app, %w{deploy@192.168.4.50}
role :web, %w{deploy@192.168.4.50}
role :db, %w{deploy@192.168.4.50}
server '192.168.4.50', roles: %w{:web, :app, :db}, user: 'deploy'

set :ssh_options, {
   #verbose: :debug,
   keys: %w(~/.ssh/id_rsa),
   auth_methods: %w(publickey)
}
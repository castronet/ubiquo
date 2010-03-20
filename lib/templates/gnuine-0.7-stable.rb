
UBIQUO_PLUGINS = [
  'ubiquo_core',
  'ubiquo_authentication',
  'ubiquo_access_control',
  'ubiquo_media',
  'ubiquo_scaffold',
  'ubiquo_jobs',
  'ubiquo_i18n',
  'ubiquo_activity',
  'ubiquo_versions',
  'ubiquo_guides'
]

EXTERNAL_PLUGINS = [
   'calendar_date_select',
   'exception_notification',
   'responds_to_parent',
   'tiny_mce',
   'paperclip'
]
# File railties/lib/rails_generator/generators/applications/app/template_runner.rb, line 69
def plugin(name, options)
  log 'plugin', name

  if options[:git] && options[:submodule]
    in_root do
      branch = "-b #{options[:branch]}" if options[:branch]
      Git.run("submodule add #{branch} #{options[:git]} vendor/plugins/#{name}")
    end
  elsif options[:git] || options[:svn]
    in_root do
      run_ruby_script("script/plugin install #{options[:svn] || options[:git]}", false)
    end
  else
    log "! no git or svn provided for #{name}.  skipping..."
  end
end

def add_plugins(plugin_names, options={})
  git_root = options[:devel] ? 'git@github.com:gnuine' : 'git://github.com/gnuine'
  plugin_names.each { |name| plugin name, :git => "#{git_root}/#{name}.git", :branch => options[:branch], :submodule => true }
end
# To ask needed settings when boostraping the app
appname             = ask("Please enter your application name, it will be used in database.yml and several other places: ")
exception_recipient = "programadors@gnuine.com"
sender_address      = "errors@gnuine.com"
# Remove rails temporary directories
["./tmp/pids", "./tmp/sessions", "./tmp/sockets", "./tmp/cache"].each do |f|
  run("rmdir ./#{f}")
end
# Hold empty dirs by adding .gitignore to each (to avoid git missing needed empty dirs)
run("find . \\( -type d -empty \\) -and \\( -not -regex ./\\.git.* \\) -exec touch {}/.gitignore \\;")

# git:rails:new_app
git :init

# Add default files to ignore (for Rails) to git
file '.gitignore', <<-CODE
log/\*.log
log/\*.pid
db/\*.db
db/\*.sqlite3
db/schema.rb
tmp/\*\*/\*
.DS_Store
doc/api
doc/app
config/database.yml
CODE
initializer 'ubiquo_config.rb', <<-CODE
Ubiquo::Config.add do |config|
  config.app_name = "#{appname}"
  config.app_title = "#{appname.gsub(/_/, " ").capitalize}"
  config.app_description = "#{appname.gsub(/_/, " ").capitalize}"
  case RAILS_ENV
  when 'development', 'test'
    config.notifier_email_from = 'railsmail@gnuine.com'
  else
    config.notifier_email_from = 'railsmail@gnuine.com'
  end
end
CODE
# Initializer for exception notifier
# Needs 3 params:
#   appname -> Application name (Ex: test)
#   exception_recipient -> email to deliver application error messages (Ex: developers@foo.com)
#   sender_adress -> email to user in from when delivering error message (Ex: notifier@foo.com)
initializer 'exception_notifier.rb', <<-CODE
#Exception notification
ExceptionNotifier.exception_recipients = %w( #{exception_recipient} )
ExceptionNotifier.sender_address = %("Application Error" <#{sender_address}>)
ExceptionNotifier.email_prefix = "[#{appname} \#\{RAILS_ENV\} ERROR]"
CODE
# Initializer for session
# Needs 1 param:
#   appname -> Application Name (Ex: test)
initializer 'session_store.rb', <<-CODE
ActionController::Base.session = {
  :key         => "_ubiquo_#{appname}_session",
  :secret      => '#{(1..40).map { |x| (65 + rand(26)).chr }.join}'
}
CODE
postgresql =  <<-CODE
base_config: &base_config
    encoding: unicode
    adapter:  postgresql
    host: localhost

development:
  <<: *base_config  
  database: #{appname}_development
  
test:
  <<: *base_config
  database: #{appname}_test

preproduction:
  <<: *base_config
  database: #{appname}_preproduction

production:
  <<: *base_config
  database: #{appname}_production
CODE

mysql = <<-CODE
base_config: &base_config
  encoding: utf8
  adapter:  mysql
  pool: 5
  username: root
  password:
  socket: /var/run/mysqld/mysqld.sock

development:
  <<: *base_config  
  database: #{appname}_development
  
test:
  <<: *base_config
  database: #{appname}_test

preproduction:
  <<: *base_config
  database: #{appname}_preproduction

production:
  <<: *base_config
  database: #{appname}_production
CODE

sqlite3 = <<-CODE
base_config: &base_config
  encoding: unicode
  adapter:  sqlite3
  pool: 5
  timeout: 5000

development:
  <<: *base_config  
  dbfile: db/#{appname}_development.db
  
test:
  <<: *base_config
  dbfile: db/#{appname}_test.db

preproduction:
  <<: *base_config
  dbfile: db/#{appname}_preproduction.db

production:
  <<: *base_config
  dbfile: db/#{appname}_production.db
CODE

adapter_message = <<-CODE


Avaliable database adapters: 

1.- postgresql
2.- mysql
3.- sqlite3

Please choose one(1/2/3):
CODE

choosen_adapter = ask(adapter_message)
case choosen_adapter
  when "2" then file 'config/database.yml', mysql
  when "3" then file 'config/database.yml', sqlite3
  else file 'config/database.yml', postgresql
end
# gnuine routes.rb
file 'config/routes.rb',
%q{ActionController::Routing::Routes.draw do |map|

  map.namespace :ubiquo do |ubiquo|
  end

  # Ubiquo plugins routes. See routes.rb from each plugin path.
  map.from_plugin :ubiquo_core
  map.from_plugin :ubiquo_authentication
  map.from_plugin :ubiquo_access_control
  map.from_plugin :ubiquo_media
  map.from_plugin :ubiquo_jobs
  map.from_plugin :ubiquo_i18n
  map.from_plugin :ubiquo_activity
  map.from_plugin :ubiquo_design
 
  ############# default routes
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
}
# default rails environment.rb
file 'config/environment.rb',
%q{# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )
  
  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "rmagick", :lib => 'RMagick'
  
  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  config.plugins = [ :ubiquo_core, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de  
  config.i18n.load_path += Dir.glob(File.join("config", "locales", "**","*.{rb,yml}"))
  config.i18n.default_locale = :ca
end
}

add_plugins(EXTERNAL_PLUGINS + UBIQUO_PLUGINS + ['ubiquo_design'], :branch => "0.7-stable")
plugin 'ubiquo_design', :git => 'gitosis@gandalf.gnuine.com:ubiquo_design.git', :submodule => true, :branch => '0.7-stable'

rake("rails:update")
rake("calendardateselect:install")
rake("ubiquo:install")
rake("db:create:all")
rake("ubiquo:db:reset")


git :add => "."
git :commit => "-a -m 'Initial #{appname} commit'"


# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
Rails.application.config.assets.precompile += %w( jquery.dataTables.css rails_admin/rails_admin.css rails_admin/rails_admin.js )
# Rails.application.config.assets.precompile += %w( js/login.js )
Rails.application.config.assets.precompile += %w( css/style.css )
Rails.application.config.assets.precompile += %w( css/main.css )
Rails.application.config.assets.precompile += %w( css/login.css )
Rails.application.config.assets.precompile += %w( css/dashboard.css )
Rails.application.config.assets.precompile += %w( css/dialogs.css )
Rails.application.config.assets.precompile += %w( css_vid/styles.css )
Rails.application.config.assets.precompile += %w( css_vid/cssgram.min.css )
# Rails.application.config.assets.precompile += %w( *.css )

Rails.application.config.assets.precompile += %w( js/QBconfig.js )
Rails.application.config.assets.precompile += %w( js/user.js )
Rails.application.config.assets.precompile += %w( js/dialog.js )
Rails.application.config.assets.precompile += %w( js/message.js )
Rails.application.config.assets.precompile += %w( js/listeners.js )
Rails.application.config.assets.precompile += %w( js/helpers.js )
Rails.application.config.assets.precompile += %w( js/app.js )
Rails.application.config.assets.precompile += %w( js/login.js )
Rails.application.config.assets.precompile += %w( js/login2.js )
Rails.application.config.assets.precompile += %w( js/route.js )
Rails.application.config.assets.precompile += %w( js_vid/config.js )
Rails.application.config.assets.precompile += %w( js_vid/helpers.js )
Rails.application.config.assets.precompile += %w( js_vid/stateBoard.js )
Rails.application.config.assets.precompile += %w( js_vid/app.js )
Rails.application.config.assets.precompile += %w( *.js )
Rails.application.config.assets.precompile += %w( *.ogg )
Rails.application.config.assets.precompile += %w( *.mp3 )
Rails.application.config.assets.precompile += %w( *.gif )
Rails.application.config.assets.precompile += %w( *.svg )
Rails.application.config.assets.precompile += %w( *.png )
Rails.application.config.assets.precompile += %w( *.jpg )






# Rails.application.config.assets.precompile += %w( js/login.js )

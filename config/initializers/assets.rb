# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
Rails.application.config.assets.paths << Rails.root.join("app/javascript")
Rails.application.config.assets.paths << Rails.root.join("vendor/javascript")
# Rails.application.config.assets.paths << Emoji.images_path

# Add bootstrap paths
Rails.application.config.assets.paths << Rails.root.join("node_modules")

# Enable the asset pipeline
Rails.application.config.assets.enabled = true

# Precompile additional assets
Rails.application.config.assets.precompile += %w[ .svg .eot .woff .ttf .scss ]
Rails.application.config.assets.precompile += %w[ bootstrap.js ]
Rails.application.config.assets.precompile += %w[ controllers/application.js controllers/index.js ]
Rails.application.config.assets.precompile += %w[ application.js ]
Rails.application.config.assets.precompile += %w[ utilities/progress_bar.js utilities/progress_bar_script.js ]

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

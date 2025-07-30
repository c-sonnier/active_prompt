# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Include engine assets
Rails.application.config.assets.precompile += %w[prompt_engine/application.css]

# Ensure engine asset paths are included
Rails.application.config.assets.paths << PromptEngine::Engine.root.join("app/assets/stylesheets")

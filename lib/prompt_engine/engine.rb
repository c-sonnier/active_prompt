module PromptEngine
  class Engine < ::Rails::Engine
    isolate_namespace PromptEngine

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: "spec/factories"
    end

    # Ensure services and clients directories are in the autoload paths
    config.autoload_paths += %W[#{config.root}/app/services]
    config.autoload_paths += %W[#{config.root}/app/clients]

    # Ensure engine's migrations are available to the host app
    # This is the standard Rails engine pattern
    # Skip this for the dummy app to avoid duplicate migrations
    initializer :append_migrations do |app|
      unless app.root.to_s.match?(root.to_s) || app.root.to_s.include?("spec/dummy")
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    # Configure asset pipeline
    initializer "prompt_engine.assets" do |app|
      # In production, look for precompiled assets first
      if Rails.env.production? && File.exist?(root.join("app/assets/builds/application.css"))
        app.config.assets.precompile += %w[prompt_engine/application.css]
        # Add the builds directory to asset paths
        app.config.assets.paths << root.join("app/assets/builds")
      else
        # In development, use the source files
        app.config.assets.precompile += %w[prompt_engine/application.css]
      end
    end

    # Define the controller hook for authentication customization
    initializer "prompt_engine.controller_hook" do
      ActiveSupport.on_load(:prompt_engine_application_controller) do
        # This hook allows host applications to add authentication
        # and other controller-level customizations
      end
    end

    # Allow middleware to be added for authentication
    # Example: PromptEngine::Engine.middleware.use(Rack::Auth::Basic) { ... }
  end
end

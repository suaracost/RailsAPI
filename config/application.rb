require_relative "boot"

# No cargamos Rails::ActiveRecord ni las demás gemas asociadas a la base de datos
require "rails"

# Seleccionamos los componentes de Rails que sí vamos a usar
require "action_controller/railtie"
require "action_mailer/railtie"
require "active_job/railtie"
require "action_cable/engine"
# Otras dependencias de Rails

Bundler.require(*Rails.groups)

module RailsTallerArquitectura
  class Application < Rails::Application
    # Elimina la configuración de ActiveRecord, ya que no lo necesitas
    # Desactiva completamente ActiveRecord
    config.generators do |g|
      g.orm :null # Desactiva el ORM predeterminado
    end

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.2

    # No cargar ActiveRecord
    config.api_only = true

    # Configuración adicional para autoload si lo necesitas
    config.autoload_lib(ignore: %w[assets tasks])

    # Configura otros aspectos de tu aplicación, por ejemplo:
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end

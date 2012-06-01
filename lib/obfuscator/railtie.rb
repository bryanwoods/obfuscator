module Obfuscator
  class Railtie < Rails::Railtie
    railtie_name :obfuscator

    rake_tasks do
      load "tasks/obfuscator.rake"
    end
  end
end

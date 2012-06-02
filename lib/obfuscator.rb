require "obfuscator/version"
require "obfuscator/utilities"
require "obfuscator/generic"
require "obfuscator/dsl"
require "obfuscator/railtie" if defined?(Rails)

module Obfuscator
  include Dsl
end

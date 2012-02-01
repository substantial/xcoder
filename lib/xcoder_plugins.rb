
module Xcode
  
  # 
  # Load the all the other gems with the prefix `xcoder-` or `xcoder_` after
  # the original xcoder library has been loaded to allow for individuals to 
  # override and provide modular functionality to the Xcoder gem.
  # 
  # This initial functionality does not allow for the exclusion of plugins. If
  # a plugin has the matching prefix it will be included.
  #
  module Plugins
    extend self
        
    XCODER_PLUGIN_PREFIX = /^xcoder[-_]/
    
    def translate_plugin_name(name)
      name = name.gsub('/', '') # Security sanitization
      name = "xcoder-" + name unless name =~ XCODER_PLUGIN_PREFIX
      name
    end

    def load_plugin_failed(name, exception)
      warn "Error loading plugin '#{name}'"
      false
    end

    def load_plugin(name)
      name = translate_plugin_name(name)
      puts "Loading plugin '#{name}'..."
      require name
      true
    rescue LoadError => e
      load_plugin_failed(name, e)
    end

    def load_all_latest_plugins
      Gem::Specification.latest_specs.map {|spec| spec.name }.each do |name|
        begin
          next true unless name =~ XCODER_PLUGIN_PREFIX
          load_plugin name
        rescue Gem::LoadError => e
          tmp = load_plugin_failed name, e
          result = tmp if !tmp
        end
      end
    end
    
  end
end

Xcode::Plugins.load_all_latest_plugins
require 'tenjin'

module Ramaze
  module View
    module Tenjin
      def self.call(action, string)
        tenjin = View.compile(string){|s|
          template = ::Tenjin::Template.new
          template.convert(s)
          template
        }
#Ramaze::Log.debug "#{self.name}: action.variables: #{action.variables.inspect}"

        # create an Engine to work with
        tenjin_engine = ::Tenjin::Engine.new(tenjin.options(action.node))

        # create context with an engine hook and action variables
        context = tenjin_engine.hook_context(action.variables)

        # extend the context with helpers
        tenjin.extend_with_helpers(action.node, context)

        # use tenjin to render the context
        # with instance variables and included helpers
        html = tenjin.render(context)

        return html, 'text/html'
      end
    end
  end
end

module Tenjin
  class Template

    # Determine the options to pass when creating the Tenjin Engine.
    # The controller node can define a :tenjin_options trait whose
    # value is a hash of options to pass to Tenjin.
    # Otherwise reasonable defaults are chosen.
    def options(node)

      # construct view search paths
      paths = node.possible_paths_for(node.view_mappings)

      # no cache in :dev mode
      cache = Ramaze.options.mode == :dev ? false : true

      # define default options
      options = {:postfix=>'.rbhtml', :path=>paths, :cache=> cache}

      # overide defaults with any passed in node's :tenjin_options trait
      tenjin_options = node.ancestral_trait[:tenjin_options]
#Ramaze::Log.debug "#{self.class}: tenjin_options: #{tenjin_options.inspect}"
      if tenjin_options.is_a?(Hash)
        options.merge!(tenjin_options)
      end
#Ramaze::Log.debug "#{self.class}: tenjin use options: #{options.inspect}"
      options
    end

    # Determine the helpers to extend the tenjin context with.
    # The controller node can define a :tenjin_helpers trait whose
    # value is an array of helper symbols to use when extending the context.
    # Otherwise all helpers are used to extend the context.
    def extend_with_helpers(node, context)
      # get array of helper symbols
      tenjin_helpers = node.ancestral_trait[:tenjin_helpers]
      if tenjin_helpers
        Innate::HelpersHelper.each_extend(context, *tenjin_helpers)
      else
        # extend the context with all the node's helpers
        helpers = []
        node.included_modules.each do |mod|
          helpers << mod if mod.name =~ /Innate::Helper::/
        end
        helpers.each do |helper|
          context.extend(helper)
        end
      end
#Ramaze::Log.debug "#{self.class}: tenjin context methods: #{context.methods.inspect}"
    end
  end
end

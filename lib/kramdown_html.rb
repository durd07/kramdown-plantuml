# frozen_string_literal: true

require 'kramdown'
require 'kramdown-parser-gfm'
require_relative 'kramdown-plantuml/log_wrapper'
require_relative 'kramdown-plantuml/plantuml_error'
require_relative 'kramdown-plantuml/options'
require_relative 'kramdown-plantuml/plantuml_diagram'
require_relative 'kramdown-plantuml/jekyll_provider'

module Kramdown
  module Converter
    # Plugs into Kramdown::Converter::Html to provide conversion of PlantUML markup
    # into beautiful SVG.
    class Html
      alias super_convert_codeblock convert_codeblock

      def convert_codeblock(element, indent)
        return super_convert_codeblock(element, indent) unless plantuml?(element)

        jekyll = ::Kramdown::PlantUml::JekyllProvider

        # If Jekyll is successfully loaded, we'll wait with converting the
        # PlantUML diagram to SVG since a theme may be configured that needs to
        # be copied to the assets directory before the PlantUML conversion can
        # be performed. We therefore place a needle in the haystack that we will
        # convert in the :site:pre_render hook.
        options = ::Kramdown::PlantUml::Options.new(@options)
        return jekyll.needle(element.value, options) if jekyll.installed?

        convert_plantuml(element.value, options)
      end

      private

      def plantuml?(element)
        element.attr['class'] == 'language-plantuml'
      end

      def convert_plantuml(plantuml, options)
        diagram = ::Kramdown::PlantUml::PlantUmlDiagram.new(plantuml, options)
        diagram.svg.to_s
      rescue StandardError => e
        raise e if options.raise_errors?

        logger = ::Kramdown::PlantUml::LogWrapper.init
        logger.error "Error while replacing needle: #{e.inspect}"
      end
    end
  end
end

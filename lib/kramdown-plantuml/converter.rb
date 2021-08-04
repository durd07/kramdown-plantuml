# frozen_string_literal: true

require_relative 'version'
require_relative 'themer'
require_relative 'plantuml_error'
require_relative 'logger'
require_relative 'executor'

module Kramdown
  module PlantUml
    # Converts PlantUML markup to SVG
    class Converter
      def initialize(options = {})
        @themer = Themer.new(options)
        @logger = Logger.init
        @executor = Executor.new
      end

      def convert_plantuml_to_svg(plantuml)
        if plantuml.nil? || plantuml.empty?
          @logger.warn ' kramdown-plantuml: PlantUML diagram is empty'
          return plantuml
        end

        plantuml = @themer.apply_theme(plantuml)
        plantuml = plantuml.strip
        log(plantuml)
        result = @executor.execute(plantuml)
        result.validate(plantuml)
        svg = result.without_xml_prologue
        wrap(svg)
      end

      private

      def wrap(svg)
        theme_class = @themer.theme_name ? "theme-#{@themer.theme_name}" : ''
        class_name = "plantuml #{theme_class}".strip

        wrapper_element_start = "<div class=\"#{class_name}\">"
        wrapper_element_end = '</div>'

        "#{wrapper_element_start}#{svg}#{wrapper_element_end}"
      end

      def log(plantuml)
        @logger.debug ' kramdown-plantuml: PlantUML converting diagram:'
        @logger.debug_with_prefix ' kramdown-plantuml: ', plantuml
      end
    end
  end
end

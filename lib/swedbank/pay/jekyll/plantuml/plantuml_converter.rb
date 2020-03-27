require 'open3'
require "swedbank/pay/jekyll/plantuml/version"

module Swedbank
  module Pay
    module Jekyll
      module Plantuml
        class Error < StandardError; end

        class Converter
          def initialize
            dir = File.dirname __dir__
            bin = File.join dir, "../../../../bin"
            bin = File.expand_path bin
            @plant_uml_jar_file = File.join bin, "plantuml.1.2020.5.jar"

            if not File.exists? @plant_uml_jar_file
              raise Error.new("'#{@plant_uml_jar_file}' does not exist")
            end

            puts @plant_uml_jar_file
          end

          def convert_plantuml_to_svg(content)

            cmd = "java -jar #{@plant_uml_jar_file} -tsvg -pipe"

            stdout, stderr, status = Open3.capture3(cmd, :stdin_data => content)

            unless stderr.empty?
              raise stderr
            end

            return stdout
          end
        end
      end
    end
  end
end

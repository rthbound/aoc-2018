require 'pay_dirt'

module Day
  module Solutions
    class Day2 < PayDirt::Base
      def initialize(options = {})
        options = {
          file_class: File,
          input_file: "lib/day/inputs/2.txt",
        }.merge(options)

        # sets instance variables from key value pairs,
        # will fail if any keys given before options aren't in options
        load_options(:day, options) do
          @input = @file_class.read(@input_file)
        end
      end

      def call
        return result(true)
      end
    end
  end
end

require 'pay_dirt'

module Day
  module Solutions
    class Day2 < PayDirt::Base
      def initialize(options = {})
        options = {
          file_class: File,
        }.merge!(options)

        load_options(:input_file, options) do
          @input = @file_class.read(@input_file)
        end
      end

      def call
        return result(true)
      end
    end
  end
end

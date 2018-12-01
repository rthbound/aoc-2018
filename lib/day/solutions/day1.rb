module Day
  module Solutions
    class Day1 < PayDirt::Base
      def initialize(options = {})
        load_options(:input_file, options) do
          @input   = File.read(@input_file).scan(/[+-]?\d+/).map(&:to_i)
        end
      end

      def call
        result(true, {
          part_one: @input.sum,
          part_two: find_first_frequency_visited_twice
        })
      end

      private

      def find_first_frequency_visited_twice
        frequency = 0 and visited = Set[frequency]

        @input.cycle do |δf|
          break frequency if visited.include? frequency += δf
          visited << frequency
        end
      end
    end
  end
end

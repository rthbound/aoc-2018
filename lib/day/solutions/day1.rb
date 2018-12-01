module Day
  module Solutions
    class Day1 < PayDirt::Base
      def initialize(options = {})
        load_options(:input_file, :day, options) do
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
        frequency = 0
        visited   = Set.new [frequency]

        @input.cycle do |i|
          frequency += i
          if visited.include?(frequency)
            result = frequency
            break(result)
          else
            visited << frequency
          end
        end
      end
    end
  end
end

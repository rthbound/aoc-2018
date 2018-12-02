require 'pay_dirt'

module Day
  module Solutions
    class Day2 < PayDirt::Base
      def initialize(options = {})
        options = {
          file_class: File,
        }.merge!(options)

        load_options(:input_file, options) do
          @input = @file_class.read(@input_file).scan /\w+/
        end
      end

      def call
        return result(true, {
          part_one: part_one,
          part_two: part_two
        })
      end

      private
      def part_one
        doubles, triples = 0, 0

        @input.each { |i|
          grouped_by_count = i.chars.group_by {|c| i.count(c) }

          doubles += 1 if grouped_by_count.has_key?(2)
          triples += 1 if grouped_by_count.has_key?(3)
        }

        doubles * triples
      end

      def part_two
        1.upto(@input.last.size) do |index|
          omitted_index = index - 1

          filtered = @input.map do |item|
            mapped = item[0...omitted_index] + item[omitted_index.next..-1]
          end

          res = filtered.detect {|x| filtered.count(x) == 2 }

          break res unless res.nil?
        end
      end
    end
  end
end

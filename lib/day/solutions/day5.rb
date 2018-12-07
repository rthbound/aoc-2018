require 'pay_dirt'
require 'pry'

module Day
  module Solutions
    class Day5 < PayDirt::Base
      def initialize(options = {})
        options = {
          file_class: File,
        }.merge!(options)

        load_options(:input_file, options) do
          @input = @file_class.read(@input_file).rstrip!
          @input = "dabAcCaCBAcCcaDA"
        end
      end

      def call
        return result(true, {
          part_one: shoot_laser_beams_at_string(@input).size,
          part_two: keep_most_tattered_target
        })
      end

      def keep_most_tattered_target
        target_space = "a".upto("z").to_a

        target_space.map {|target|
          current_input = @input.tr("#{target}#{target.swapcase}", "")
          shoot_laser_beams_at_string(current_input).size
        }.min
      end

      def shoot_laser_beams_at_string(str)
        laser = 0
        target = str.dup

        loop do
          if target[laser] == target[laser.next].swapcase
            target.slice!(laser..laser.next)
            laser = laser.pred.clamp(0, Float::INFINITY)
          else
            laser = laser.next
          end

          break(target) unless target[laser..laser.next].size == 2
        end
      end
    end
  end
end

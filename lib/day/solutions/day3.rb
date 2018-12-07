require 'pay_dirt'

module Day
  module Solutions
    class Day3 < PayDirt::Base
      def initialize(options = {})
        options = {
          file_class: File,
        }.merge!(options)

        load_options(:input_file, options) do
          @input = @file_class.read(@input_file)
          @grid = {} # Hash table, k/v pairs where k is grid coord on complex plane
          @claims = @input.scan(/\#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/).map do
            |claim_id, offset_from_left, offset_from_top, width, height|
            Hash[
              [
                :claim_id, :offset_from_left, :offset_from_top, :width, :height
              ].zip [
                claim_id, offset_from_left.to_i, offset_from_top.to_i, width.to_i, height.to_i
              ]
            ]
          end
        end
      end

      def call
        @spoiled = Set.new
        @claims.each {|claim| draw_claim(claim) }
        result true, {
          part_one: @grid.count {|k,v| v.size > 1 },
          part_two: @spoiled ^ @claims.map {|x| x[:claim_id]}
        }
      end

      def draw_claim(claim)
        top_left_corner_of_claim = locate_top_left_corner(claim)
        claim[:width].times { |rightward|
          claim[:height].times { |downward|
            coord = top_left_corner_of_claim + Complex(rightward, (downward))
            if @grid[coord].nil?
              @grid[coord] = Set[claim[:claim_id]]
            else
              @grid[coord] << claim[:claim_id]
              @spoiled |= @grid[coord]
            end
          }
        }
      end

      def locate_top_left_corner(claim)
        Complex(claim[:offset_from_left], (claim[:offset_from_top]))
      end
    end
  end
end

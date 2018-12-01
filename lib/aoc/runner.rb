module AOC
  class Runner
    def initialize
      @solution_space = Hash["1".upto("25").map { |day|
        [
          day,
          begin
            require_relative "../day/solutions/day#{day}"
          rescue LoadError
            false
          end
        ]
      }]
    end

    def call
      puts Benchmark.measure {
        Benchmark.bm { |bm|
          @solution_space.each do |day, si_o_no|
            if si_o_no
              bm.report("day#{day}") { solved(day) }
            else
              puts "day#{day}  -.------   -.------   -.------ (  -.------)"
            end
          end
        }
      }
    end

    private
    def solution(day)
      Kernel.const_get "Day::Solutions::Day#{day.to_s}"
    end

    def solved(day)
      solution(day).new(input_file: "lib/day/inputs/#{day.to_s}.txt").call.data
    end
  end
end

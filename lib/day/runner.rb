module Day
  class Runner
    def initialize(day:, options: {})
      @solution = Kernel.const_get "Day::Solutions::Day#{day.to_s}"
      @day = day
      @options = {
        input_file: "lib/day/inputs/#{day.to_s}.txt",
      }.merge!(options)
    end

    def call
      run_day
    end

    private
    def run_day
      puts "<day#{@day}>"
      puts Benchmark.measure { puts @solution.new(@options).call.data }
      puts "</day#{@day}>"
    end
  end
end

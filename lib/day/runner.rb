module Day
  class Runner
    def initialize(day:, options: {})
      require_relative "solutions/day#{day.to_s}"
      @solution = Kernel.const_get "Day::Solutions::Day#{day.to_s}"
      @options = {
        day: day.to_s,
        input_file: "lib/day/inputs/#{day.to_s}.txt"
      }.merge!(options)
    end

    def call
      puts "Running Day #{@options[:day]}"
      puts Benchmark.measure {
        puts @solution.new(@options).call.data
      }
      puts "Finished running Day #{@options[:day]}"
    end
  end
end

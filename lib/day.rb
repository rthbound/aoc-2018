require 'benchmark'
require 'pry'
require 'pay_dirt'
require_relative 'day/runner'
require_relative 'day/solutions'

"1".upto("25") { |day|
  begin
    require_relative "day/solutions/day#{day}"
  rescue LoadError
    next
  end
}

module Day
end

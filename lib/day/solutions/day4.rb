require 'pay_dirt'

module Day
  module Solutions
    class Day4 < PayDirt::Base
      def initialize(options = {})
        options = {
          file_class: File,
        }.merge!(options)

        load_options(:input_file, options) do
          @input = @file_class.read(@input_file)
          @input = @file_class.read(@input_file)
#         [1518-06-22 00:46] falls asleep
#         [1518-08-15 00:39] wakes up
#         [1518-06-26 23:50] Guard #2377 begins shift
          @input = @input.scan(/\[(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})\] (Guard #\d+)? ?(falls asleep|wakes up|begins shift)/)
          @guard_on_duty = OpenStruct.new(guard: nil, awake: true)
          @history = {}
        end
      end

      # Strategy 1: Find the guard that has the most minutes asleep. What minute does that guard spend asleep the most?
      # What is the ID of the guard you chose multiplied by the minute you chose?
      def call
        @input.each_cons(2) do |current_event, next_event|
          changing_of_the_guard(current_event)

          current_event = parse_event(current_event)
          next_event    = parse_event(next_event)

          log_status(current_event) if current_event[:hour] == "00"

          current_time  = Time.new *current_event.values_at(:year, :month, :day, :hour, :minute)
          next_time     = Time.new *next_event.values_at(   :year, :month, :day, :hour, :minute)

          while current_time < next_time do
            current_time += 60
            break unless current_time.strftime("%H") == "00"
            current_event[:minute] = current_time.strftime("%M")
            current_event[:day   ] = current_time.strftime("%d")
            current_event[:month ] = current_time.strftime("%m")
            current_event[:year  ] = current_time.strftime("%Y")
            log_status(current_event)
          end
        end

        changing_of_the_guard(@input[-1])
        current_event = parse_event(@input[-1])
        current_time  = Time.new *current_event.values_at(:year, :month, :day, :hour, :minute)

        log_status(current_event) if current_event[:hour] == "00"

        while current_time.strftime("%H") == "00" do
          current_time += 60
          break unless current_time.strftime("%H") == "00"
          current_event[:minute] = current_time.strftime("%M")
          current_event[:day   ] = current_time.strftime("%d")
          current_event[:month ] = current_time.strftime("%m")
          current_event[:year  ] = current_time.strftime("%Y")
          log_status(current_event)
        end
        guard = @history.map {|guard, days| [guard, days.map {|date, hours| hours.values.flatten.count {|awake| awake == false } }.sum ] }.max_by(&:last).first
        result(true, {
          part_one: @history[guard][:minute_tally].to_a.max_by(&:last).first.to_i * guard[/\d+/].to_i
        })
      end

      def log_status(event)
        @history[event.fetch(:guard)] ||= {}
        @history[event.fetch(:guard)][event.values_at(:year, :month, :day).join] ||= Hash[
          "00".upto("59").zip([])
        ]
        @history[event.fetch(:guard)][event.values_at(:year, :month, :day).join][event[:minute]] = @guard_on_duty.awake

        log_sleepy_time(event) unless @guard_on_duty.awake
      end

      def log_sleepy_time(event)
        @history[@guard_on_duty.guard][:minute_tally] ||= {}
        @history[@guard_on_duty.guard][:minute_tally][event[:minute]] ||= 0
        @history[@guard_on_duty.guard][:minute_tally][event[:minute]] += 1
      end

      def changing_of_the_guard(event)
        event = parse_event(event)

        @guard_on_duty.guard = event[:guard]
        @guard_on_duty.awake = event[:event].match? /(wakes up|begins shift)/
      end

      def guard_index
        5
      end

      def parse_event(event)
        event = {
          year:   event[0],
          month:  event[1],
          day:    event[2],
          hour:   event[3],
          minute: event[4],
          guard:  event[guard_index] || @guard_on_duty.guard,
          event:  event[-1]
        }
      end
    end
  end
end

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
          @input = @input.scan(
            /\[(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})\] (Guard #\d+)? ?(falls asleep|wakes up|begins shift)/
          ).map {|year, month, day, hour, minute, guard_id, event|
            [
              Time.new(year, month, day, hour, minute),
              guard_id,
              event
            ]
          }.sort_by(&:first)
          @current_guard = nil

          @history = {}
        end
      end

      def call
        return result(true, whatever)
      end

      private
      def whatever
        lol = @input.map { |log_entry| parse_log_entry(*log_entry) }


        lol_e = lol.map

        extras = Array.new.tap { |accum|
          loop do
            accum.push lol_e.peek

            current_event_time,
            current_guard_id,
            current_message,
            current_status = lol_e.next

            next_event_time,
            next_guard_id,
            next_message,
            next_status = lol_e.peek

            loop do
              if next_event_time - current_event_time == 60
                break
              else
                case (current_event_time + 60).hour
                when 23,0
                  current_event_time += 60
                  accum.push([current_event_time, current_guard_id, current_message, current_status])
                else
                  break
                end
              end
            end
          rescue StopIteration
            break
          end
        }.
          reject {|time, *| time.hour == 23 }.
          group_by {|_,g,_| g }.
          map {|key,records| [key, records.group_by {|t,*|  t.strftime("%Y-%m-%d")}] }.to_h
        sucker = extras.map {|guard,entries| [guard, entries.values.flatten(1).count {|x| x.last == "#" }] }.to_h.max_by {|k,v| v }.first
        weak_spot = extras[sucker].values.flatten(1).select {|entry| entry.last == "#" }.map(&:first).map(&:min).group_by(&:inspect).max_by {|k,v| v.size }[-1][-1]
        sucker2, times = extras.map {|guard, entries| [guard, entries.values.flatten(1).select {|e| e.last == "#"}.group_by{|t, *| t.min }.map {|k,v| [k,v.size] }.to_h]}.to_h.map {|guard, tally| [ guard, tally.max_by {|k,v| v } ] }.to_h.max_by {|k,v| v&.last || 0 }
        {
          part_one: { sucker: sucker, weak_spot: weak_spot, solution: weak_spot * sucker[/\d+/].to_i },
          part_two: { sucker: sucker2, weak_spot: times[0], solution: sucker2[/\d+/].to_i * times[0] }
        }
      end
      def parse_log_entry(time, guard_id, event)
        guard = guard_id.nil? ? @current_guard : guard_id
        [
          time,
          @current_guard = guard,
          event,
          case event
          when /begins shift/
            "."
          when /falls asleep/
            "#"
          when /wakes up/
            "."
          end
        ]
      end
    end
  end
end

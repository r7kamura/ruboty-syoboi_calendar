require "active_support/core_ext/enumerable"
require "active_support/core_ext/numeric/time"
require "active_support/core_ext/date"
require "active_support/core_ext/time"

module Ellen
  module Handlers
    class SyoboiCalendar < Base
      on(/list anime\z/, name: "list", description: "List today's anime")

      env :SYOBOI_CALENDAR_CHANNEL_IDS, "Comma-separated channel IDs to filter programs", optional: true

      def list(message)
        message.reply(description)
      end

      private

      def description
        if programs.empty?
          "No programs found"
        else
          programs.sort_by(&:started_at).map do |program|
            count = " ##{program.count}" if program.count
            %<#{program.started_at.strftime("%Y-%m-%d %H:%M")} #{program.title.name}#{count}>
          end.join("\n")
        end
      end

      def descriptions
        @descriptions ||= programs_sorted_by_started_at.map do |program|
          "#{program.started_at_in_string} #{titles_index_by_id[program.title_id].title} #{program.count}"
        end
      end

      def programs
        @programs ||= ::SyoboiCalendar::Client.new.programs(program_options)
      end

      def program_options
        {
          played_from: played_from,
          played_to: played_to,
          channel_id: channel_ids,
          includes: [:channel, :title],
        }.reject {|key, value| value.nil? }
      end

      def channel_ids
        ENV["SYOBOI_CALENDAR_CHANNEL_IDS"]
      end

      def now
        @now ||= Time.now
      end

      def played_from
        now
      end

      # 04:00 ~ 28:00
      def played_to
        if now.hour >= 4
          now.tomorrow.beginning_of_day + 4.hour
        else
          now.beginning_of_day + 4.hour
        end
      end
    end
  end
end

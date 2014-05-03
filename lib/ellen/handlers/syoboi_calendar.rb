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
        if descriptions.empty?
          "No programs found"
        else
          descriptions.join("\n")
        end
      end

      def descriptions
        @descriptions ||= programs_sorted_by_started_at.map do |program|
          "#{program.started_at_in_string} #{titles_index_by_id[program.title_id].title} #{program.count}"
        end
      end

      def client
        @client ||= ::SyoboiCalendar::Client.new
      end

      def titles_index_by_id
        @titles_by_id ||= titles.index_by(&:id)
      end

      def titles
        [get_titles.TitleLookupResponse.TitleItems.TitleItem].flatten.map do |title|
          Ellen::SyoboiCalendar::Title.new(
            id: title.id,
            title: title.Title,
            short_title: title.ShortTitle,
          )
        end
      end

      def get_titles
        client.titles(title_options)
      end

      def title_options
        {
          title_id: title_ids_in_programs.join(",")
        }
      end

      def title_ids_in_programs
        programs.map do |program|
          program.title_id
        end
      end

      def programs_sorted_by_started_at
        programs.sort_by(&:started_at)
      end

      def programs
        @programs ||= get_programs.map do |program|
          Ellen::SyoboiCalendar::Program.new(
            count: program.Count,
            channel_id: program.ChID,
            sub_title: program.STSubTitle,
            title_id: program.TID,
            started_at: program.StTime,
            finished_at: program.EdTime,
          )
        end
      end

      def get_programs
        if items = client.programs(program_options).ProgLookupResponse.ProgItems
          [items.ProgItem].flatten.compact
        else
          []
        end
      end

      def program_options
        {
          played_from: played_from,
          played_to: played_to,
          channel_id: channel_ids,
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

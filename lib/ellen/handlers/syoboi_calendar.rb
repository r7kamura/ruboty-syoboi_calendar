require "active_support/core_ext/numeric/time"
require "active_support/core_ext/time"

module Ellen
  module Handlers
    class SyoboiCalendar < Base
      on(/list anime\z/, name: "list", description: "List today's anime")

      def list(message)
        message.reply(descriptions.join("\n"))
      end

      private

      def descriptions
        programs_sorted_by_started_at.map do |program|
          "#{program[:started_at].strftime("%Y-%m-%d %H:%M")} #{titles_by_id[program[:title_id]][:title]} #{program[:count]}"
        end
      end

      def client
        @client ||= ::SyoboiCalendar::Client.new
      end

      def titles_by_id
        @titles_by_id ||= titles.inject({}) do |table, title|
          table.merge(title[:id] => title)
        end
      end

      def titles
        [get_titles.TitleLookupResponse.TitleItems.TitleItem].flatten.map do |title|
          {
            id: title.id,
            title: title.Title,
            short_title: title.ShortTitle,
          }
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
          program[:title_id]
        end
      end

      def programs_sorted_by_started_at
        programs.sort_by do |program|
          program[:started_at]
        end
      end

      def programs
        @programs ||= [get_programs.ProgLookupResponse.ProgItems.ProgItem].flatten.map do |program|
          {
            count: program.Count,
            channel_id: program.ChID,
            sub_title: program.STSubTitle,
            title_id: program.TID,
            started_at: Time.parse(program.StTime),
            finished_at: Time.parse(program.EdTime),
          }
        end
      end

      def get_programs
        client.programs(program_options)
      end

      def program_options
        {
          played_from: played_from,
          played_to: played_to,
        }
      end

      def played_from
        Time.now
      end

      def played_to
        Time.now.end_of_day
      end
    end
  end
end

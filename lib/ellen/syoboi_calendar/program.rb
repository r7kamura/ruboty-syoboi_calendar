module Ellen
  module SyoboiCalendar
    class Program < Record

      property(
        :channel_id,
        :count,
        :sub_title,
        :title_id,
      )

      time_property(
        :finished_at,
        :started_at,
      )

      def started_at_in_string
        started_at.strftime("%Y-%m-%d %H:%M")
      end
    end
  end
end

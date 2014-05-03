module Ellen
  module SyoboiCalendar
    class Program
      class << self
        def property(*names)
          names.each do |name|
            define_method(name) do
              properties[name]
            end
          end
        end

        def time_property(*names)
          names.each do |name|
            define_method(name) do
              Time.parse(properties[name])
            end
          end
        end
      end

      attr_reader :properties

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

      def initialize(properties)
        @properties = properties
      end

      def started_at_in_string
        started_at.strftime("%Y-%m-%d %H:%M")
      end
    end
  end
end

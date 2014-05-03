module Ellen
  module SyoboiCalendar
    class Record
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

      def initialize(properties)
        @properties = properties
      end
    end
  end
end

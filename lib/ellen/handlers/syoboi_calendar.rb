module Ellen
  module Handlers
    class SyoboiCalendar < Base
      on(/list anime\z/, name: "list", description: "List today's anime")

      def list(message)
        message.reply("Not yet implemented")
      end
    end
  end
end

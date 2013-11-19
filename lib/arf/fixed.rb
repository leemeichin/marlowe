require 'travis'

module Arf
  class Fixed < LEDNotification

    def color
      LEDBoard::Color::INVERSE_GREEN
    end

    def message
      "FIXED THE BUILD!"
    end

  end
end

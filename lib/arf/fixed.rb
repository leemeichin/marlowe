require 'travis'

class Arf
  class Fixed < LEDNotification

    def color
      LEDBoard::Color::INVERSED_GREEN
    end

    def message
      "FIXED THE BUILD!"
    end

  end
end

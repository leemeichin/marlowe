require 'travis'

class Arf
  class Fixed < LEDNotification

    def color
      LEDBoard::Color::GREEN
    end

    def message
      "     PASSED"
    end

  end
end

require 'travis'

class Arf
  class Broken < LEDNotification

    def color
      LEDBoard::Color::RED
    end

    def message
      "     BROKEN"
    end

  end
end

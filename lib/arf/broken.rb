require 'travis'

class Arf
  class Broken < LEDNotification

    def color
      LEDBoard::Color::INVERSED_RED
    end

    def message
      "BROKE THE BUILD"
    end

  end
end

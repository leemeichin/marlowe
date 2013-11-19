require 'travis'

module Arf
  class Broken < LEDNotification

    def color
      LEDBoard::Color::INVERSE_RED
    end

    def message
      "BROKE THE BUILD"
    end

  end
end

class Arf
  class LEDNotification

    attr_reader :event

    def initialize(event: nil)
      @event = event
    end

    def repo_name
      event.payload["repository"]["slug"]
    end

    def message
      raise NotImplementedError, "Subclasses must add their own message."
    end

    def color
      raise NotImplementedError, "Subclasses must define their own color"
    end

    def transmit!
      with_led_board do |board|

        text = LEDBoard::Page.new(repo_name.upcase,
          waiting: LEDBoard::Waiting::FAST,
          color: color,
          font: LEDBoard::Font::BOLD
        )
        
        board.send(text)
      end
    end

    private
    def with_led_board
      board = LEDBoard.connect(1)
      sleep 1
      yield board
      board.disconnect
    end
  end
end

class Arf
  class LEDNotification

    attr_reader :event

    def initialize(event: nil)
      @event = event
    end

    def hero_or_culprit
      event.payload["build"]["author_name"]
    end

    def repo_name
      event.payload["repository"]["slug"][/[^\/]+$/]
    end

    def message
      raise NotImplementedError, "Subclasses must add their own message."
    end

    def color
      raise NotImplementedError, "Subclasses must define their own color"
    end

    def transmit!
      with_led_board do |board|
        pages = []
        
        pages << LEDBoard::Page.new(hero_or_culprit,
          page: 'A',
          waiting: LEDBoard::Waiting::FAST,
          leading: LEDBoard::Leading::SNOW,
          lagging: LEDBoard::Lagging::IMMEDIATE,
          color: LEDBoard::Color::ORANGE
        )

        pages << LEDBoard::Page.new(message,
          page: 'B',
          leading: LEDBoard::Leading::IMMEDIATE,
          lagging: LEDBoard::Lagging::IMMEDIATE,
          waiting: LEDBoard::Waiting::MEDIUM,
          color: color,
          font: LEDBoard::Font::BOLD
        )

        pages << LEDBoard::Page.new(repo_name,
          page: 'C',
          waiting: LEDBoard::Waiting::FAST,
          color: LEDBoard::Color::ORANGE,
        )

        schedule = LEDBoard::Schedule.new(['A', 'B', 'C'])
        pages.each(&board.method(:send))
        board.send(schedule)
      end
    end

    private
    def with_led_board
      board = LEDBoard.connect(1)
      board.send " " # clear the board
      sleep 1
      yield board
      board.disconnect
    end
  end

  module ::LEDBoard::Display
    MIDDLE_FAST_BLINK = 'R'
  end
end

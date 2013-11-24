module Marlowe
  class Message

    COLORS = {
      'failed'  => LEDBoard::Color::RED,
      'errored' => LEDBoard::Color::YELLOW,
      'passed'  => LEDBoard::Color::GREEN
    }.freeze

    attr_reader :event, :state

    def initialize(event: nil, state: nil)
      @event, @state = event, state
    end

    def repo_name
      event.payload["repository"]["slug"][/[^\/]+$/]
    end


    def send!
      with_led_board do |board|
        text = LEDBoard::Page.new(repo_name.upcase,
          waiting: LEDBoard::Waiting::FAST,
          color: COLORS[state],
          font: LEDBoard::Font::BOLD
        )

        board.send(text)
      end
    end

    private
    def with_led_board
      board = LEDBoard.connect(1)
      yield board
      board.disconnect
    end
  end
end

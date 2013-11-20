class Arf
  class LEDNotification

    attr_reader :build

    def initialize(build: nil)
      @build = build
    end

    def hero_or_culprit
      build.commit.author_name
    end

    def repo_name
      build.repository.name
    end

    def message
      raise NotImplementedError, "Subclasses must add their own message."
    end

    def color
      raise NotImplementedError, "Subclasses must define their own color"
    end

    def transmit!
      pages = [].tap do |p|
        p << LEDBoard::Page.new(hero_or_culprit,
          page: 'A',
          waiting: LEDBoard::Waiting::SLOW,
          leading: LEDBoard::Leading::SNOW,
          lagging: LEDBoard::Lagging::SNOW,
          color: LEDBoard::Color::ORANGE
        )

        p << LEDBoard::Page.new(message,
          page: 'B',
          leading: LEDBoard::Leading::SCROLL_LEFT,
          lagging: LEDBoard::Lagging::SCROLL_LEFT,
          waiting: LEDBoard::Waiting::MEDIUM,
          display: LEDBoard::Display::MIDDLE_FAST_BLINK,
          color: color,
          font: LEDBoard::Font::BOLD
        )

        p << LEDBoard::Page.new(repo_name,
          page: 'C',
          waiting: LEDBoard::Waiting::MEDIUM,
          color: LEDBoard::Color::ORANGE,
        )
      end

      schedule = LEDBoard::Schedule.new(pages.map(&:page))

      pages.each {|page| board.send(page) }
      board.send(schedule)
    end
  end

  module ::LEDBoard::Display
    MIDDLE_FAST_BLINK = 'R'
  end
end

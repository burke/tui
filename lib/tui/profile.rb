# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Profile
    extend(T::Sig)
    extend(T::Generic)
    interface!

    autoload(:ASCII,     'tui/profile/ascii')
    autoload(:ANSI,      'tui/profile/ansi')
    autoload(:ANSI256,   'tui/profile/ansi256')
    autoload(:TrueColor, 'tui/profile/true_color')

    sig { abstract.params(c: Color).returns(Color) }
    def convert(c); end

    sig { abstract.params(hex: String).returns(Color) }
    def color(hex); end

    sig { params(term: T.nilable(String), colorterm: T.nilable(String), stdout: IO).returns(Profile) }
    def self.current(term: ENV['TERM'], colorterm: ENV['COLORTERM'], stdout: STDOUT)
      return(Profile::ASCII) unless stdout.tty?

      case colorterm&.downcase
      when '24bit', 'truecolor'
        if term == 'screen' || !term&.start_with?('screen')
          # enable TrueColor in tmux, but not old-school screen
          return(Profile::TrueColor)
        end
      when 'yes', 'true'
        return(Profile::ANSI256)
      end

      return(Profile::ANSI256) if term&.include?('256color')
      return(Profile::ANSI) if term&.include?('color')
      Profile::ASCII
    end
  end
end

# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module ColorProfile
    extend(T::Sig)
    extend(T::Generic)
    interface!

    autoload(:ASCII,     'tui/color_profile/ascii')
    autoload(:ANSI,      'tui/color_profile/ansi')
    autoload(:ANSI256,   'tui/color_profile/ansi256')
    autoload(:TrueColor, 'tui/color_profile/true_color')

    sig { abstract.params(c: Color).returns(T.nilable(Color)) }
    def convert(c); end

    sig { abstract.params(spec: String).returns(T.nilable(Color)) }
    def color(spec); end

    sig { params(term: T.nilable(String), colorterm: T.nilable(String), stdout: IO).returns(ColorProfile) }
    def self.detect(term: ENV['TERM'], colorterm: ENV['COLORTERM'], stdout: STDOUT)
      return(ColorProfile::ASCII) unless stdout.tty?

      case colorterm&.downcase
      when '24bit', 'truecolor'
        if term == 'screen' || !term&.start_with?('screen')
          # enable TrueColor in tmux, but not old-school screen
          return(ColorProfile::TrueColor)
        end
      when 'yes', 'true'
        return(ColorProfile::ANSI256)
      end

      return(ColorProfile::ANSI256) if term&.include?('256color')
      return(ColorProfile::ANSI) if term&.include?('color')
      ColorProfile::ASCII
    end
  end
end

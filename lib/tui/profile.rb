# typed: strict
# frozen_string_literal: true
require('tui')

module TUI
  module Profile
    extend(T::Sig)

    def self.current
      return(Profile::ASCII) unless $stdout.tty?
      term = ENV['TERM']

      case ENV['COLORTERM'].downcase
      when '24bit', 'truecolor'
        if term == 'screen' || !term.start_with?('screen')
          # enable TrueColor in tmux, but not old-school screen
          return(Profile::TrueColor)
        end
      when 'yes', 'true'
        return(Profile::ANSI256)
      end

      return(Profile::ANSI256) if term.contains?('256color')
      return(Profile::ANSI) if term.contains?('color')
      Profile::ASCII
    end
  end
end

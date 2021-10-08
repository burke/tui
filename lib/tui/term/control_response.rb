# typed: strict
# frozen_string_literal: true
require('tui')
require('io/console')

module TUI
  module Term
    class ControlResponse
      extend(T::Sig)

      S_INIT      = :init
      S_CSI       = :csi
      S_OSC_KEY   = :osc_key
      S_OSC_VALUE = :osc_value
      S_ANSI_ESC  = :ansi_esc

      class ANSISequence
        extend(T::Sig)

        sig { returns(String) }
        attr_reader(:code)

        sig { returns(T::Array[Integer]) }
        attr_reader(:args)

        sig { params(code: String, args: T::Array[Integer]).void }
        def initialize(code, args)
          @code = code
          @args = args
        end
      end

      class ParseError < StandardError
        extend(T::Sig)

        sig { params(msg: String, state: Symbol, index: Integer, desc: String).void }
        def initialize(msg, state, index, desc)
          @msg = msg
          @state = state
          @index = index
          @desc = desc
          super()
        end

        sig { returns(String) }
        def to_s
          "parse error: #{@desc}: at index #{@index} in string #{@msg} (state:#{@state})"
        end
      end

      sig { params(msg: String).returns(ControlResponse) }
      def self.parse(msg)
        state = S_INIT
        osc = T.let({}, T::Hash[Integer, String])
        ansi = T.let([], T::Array[ANSISequence])
        curr = +''
        prev = +''
        args = []
        msg.each_byte.with_index do |b, i|
          b = b.chr
          case state
          when S_INIT
            case b
            when "\x1b"
              state = S_CSI
            else
              raise(ParseError.new(msg, state, i, 'unexpected byte'))
            end
          when S_CSI
            case b
            when ']'
              curr = +''
              state = S_OSC_KEY
            when '['
              curr = +''
              state = S_ANSI_ESC
            else
              raise(ParseError.new(msg, state, i, 'unexpected byte'))
            end
          when S_OSC_KEY
            case b
            when ';'
              prev = curr
              curr = +''
              state = S_OSC_VALUE
            else
              curr << b
            end
          when S_OSC_VALUE
            case b
            when "\a"
              osc[Integer(prev)] = curr
              curr = +''
              prev = +''
              state = S_INIT
            else
              curr << b
            end
          when S_ANSI_ESC
            case b
            when ';'
              args << Integer(curr)
              curr = +''
            when /[a-zA-Z]/
              args << Integer(curr)
              curr = +''
              ansi << ANSISequence.new(b, args)
              args = []
              state = S_INIT
            else
              curr << b
            end
          else
            # :nocov: - can't really force  this error, it won't happen in
            # practice unless there's a bug elsewhere in this function.
            raise(ParseError.new(msg, state, i, 'unexpected state'))
            # :nocov:
          end
        end
        if state != S_INIT
          raise(ParseError.new(msg, state, msg.size, 'incomplete input'))
        end
        new(osc, ansi)
      end

      private_class_method(:new)

      sig { params(osc: T::Hash[Integer, String], ansi: T::Array[ANSISequence]).void }
      def initialize(osc, ansi)
        @osc = osc
        @ansi = ansi
      end

      sig { params(attr: Integer).returns(T.nilable(String)) }
      def osc_attribute(attr)
        @osc[attr]
      end

      sig { returns(T::Array[Integer]) }
      def osc_attributes
        @osc.keys
      end

      sig { returns(T::Array[ANSISequence]) }
      def ansi_sequences
        @ansi
      end
    end
  end
end

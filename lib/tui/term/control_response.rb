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

      sig { params(msg: String).returns(ControlResponse) }
      def self.parse(msg)
        state = S_INIT
        data = {}
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
              raise("unexpected byte: #{b} at index #{i} in string #{msg} (state:#{state})")
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
              raise("unexpected byte: #{b} at index #{i} in string #{msg} (state:#{state})")
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
              data[:osc] ||= {}
              data[:osc][Integer(prev)] = curr
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
              data[:ansi] ||= []
              data[:ansi] << [*args, b]
              args = []
              state = S_INIT
            else
              curr << b
            end
          else
            raise('unexpected state')
          end
        end
        if state != S_INIT
          raise("incomplete input msg=#{msg} (final state:#{state})")
        end
        new(data)
      end

      private_class_method(:new)

      sig { returns(T.untyped) }
      attr_reader(:data)

      sig { params(data: T.untyped).void }
      def initialize(data)
        @data = data
      end
    end
  end
end

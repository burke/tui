# typed: strict
# frozen_string_literal: true
require('tui')
require('io/console')

module TUI
  module Term
    module Query
      Error = Class.new(StandardError)

      class << self
        extend(T::Sig)

        sig { params(key: String).returns(T.nilable(T::Array[Integer])) }
        def dsr(key = 'R')
          cr = osc_dsr_query([])
          cr.ansi_sequences.detect { |els| els.code == key }&.args
        rescue Errno::ENODEV, Errno::ENOTTY
          raise(Error, "failed to query device status report entry '#{key}'")
        end

        sig { params(attribute: Integer).returns(String) }
        def osc(attribute)
          cr = osc_dsr_query([attribute])
          if (attr = cr.osc_attribute(attribute))
            return attr
          end
          raise(Error, "failed to query OSC attribute #{attribute}")
        rescue Errno::ENODEV, Errno::ENOTTY
          raise(Error, "failed to query OSC attribute #{attribute}")
        end

        private

        sig { params(osc_attributes: T::Array[Integer]).returns(ControlResponse) }
        def osc_dsr_query(osc_attributes)
          response = stdin.raw do
            stdin.noecho do
              msg = +''
              # first, send OSC query, which is ignored by terminals without support
              osc_attributes.each do |attr|
                msg << CSI + OSC + attr.to_s + ';?' + BEL
              end
              # then, query cursor position, even if the user didn't want it,
              # because it's supported by ~all terminals and will make the
              # readpartial call not hang when called on a terminal not
              # supporting OSC, which will print nothing otherwise.
              msg << CSI + DEVICE_STATUS_REPORT_SEQ
              stdout.print(msg)
              stdin.readpartial(128)
            end
          end
          ControlResponse.parse(response)
        end

        # mocked in tests, because idk how else to test this.
        sig { returns(IO) }
        def stdin
          # :nocov: since this is the production impl, which we mock in tests
          STDIN
          # :nocov:
        end

        sig { returns(IO) }
        def stdout
          # :nocov: since this is the production impl, which we mock in tests
          STDOUT
          # :nocov:
        end
      end
    end
  end
end

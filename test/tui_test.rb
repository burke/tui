# typed: false
# frozen_string_literal: true
require('test_helper')
require('set')

class TUITest < Minitest::Test
  def test_version
    assert_match(/^\d+\.\d+\.\d+/, TUI::VERSION)
  end

  def test_resolve_all_autoloads
    resolve_constants(TUI)
  end

  private

  def resolve_constants(base)
    @constants = Set.new
    resolve_constants_recur(base)
  ensure
    @constants = nil
  end

  def resolve_constants_recur(base, hist = [])
    base.constants.each do |const|
      nxt = base.const_get(const)
      next unless nxt.is_a?(Module)
      next unless nxt.name.start_with?("#{TUI.name}::")
      next if @constants.include?(nxt)
      @constants << nxt
      resolve_constants_recur(nxt, [nxt, *hist]) unless hist.include?(nxt)
    end
  end
end

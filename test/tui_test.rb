# typed: false
# frozen_string_literal: true
require('test_helper')

class TUITest < Minitest::Test
  def test_version
    assert_match(/^\d+\.\d+\.\d+/, TUI::VERSION)
  end
end

# typed: true
# frozen_string_literal: true
require('test_helper')
require('stringio')

module TUI
  class TermTest < Minitest::Test

    def check(seq, actual)
      assert_equal(Term::CSI, actual[0..1])
      assert_equal(seq, actual[2..-1])
    end

    def test_escape_sequences
      check('0m',     Term.reset)
      check('?1049h', Term.alt_screen)
      check('?1049l', Term.exit_alt_screen)
      assert_equal("\x1b[2J\x1b[1;1H", Term.clear_screen)
      check('8;9H', Term.move_cursor(8, 9))
      check('?25l', Term.hide_cursor)
      check('?25h', Term.show_cursor)
      check('s', Term.save_cursor_position)
      check('u', Term.restore_cursor_position)
      check('1A', Term.cursor_up)
      check('8A', Term.cursor_up(8))
      check('1B', Term.cursor_down)
      check('8B', Term.cursor_down(8))
      check('1C', Term.cursor_forward)
      check('8C', Term.cursor_forward(8))
      check('1D', Term.cursor_back)
      check('8D', Term.cursor_back(8))
      check('1E', Term.cursor_next_line)
      check('8E', Term.cursor_next_line(8))
      check('1F', Term.cursor_prev_line)
      check('8F', Term.cursor_prev_line(8))
      check('2K', Term.clear_line)
      check('1K', Term.clear_line_left)
      check('0K', Term.clear_line_right)
      assert_equal("\x1b[2K\x1b[1A\x1b[2K", Term.clear_lines)
      assert_equal("\x1b[2K\x1b[1A\x1b[2K\x1b[1A\x1b[2K", Term.clear_lines(2))
      check('1S', Term.scroll_up)
      check('8S', Term.scroll_up(8))
      check('1T', Term.scroll_down)
      check('8T', Term.scroll_down(8))
      check('8;9r', Term.change_scrolling_region(8, 9))
      check('8L', Term.insert_lines(8))
      check('8M', Term.delete_lines(8))
      check('?9h', Term.enable_mouse_press)
      check('?9l', Term.disable_mouse_press)
      check('?1000h', Term.enable_mouse)
      check('?1000l', Term.disable_mouse)
      check('?1001h', Term.enable_mouse_hilite)
      check('?1001l', Term.disable_mouse_hilite)
      check('?1002h', Term.enable_mouse_cell_motion)
      check('?1002l', Term.disable_mouse_cell_motion)
      check('?1003h', Term.enable_mouse_all_motion)
      check('?1003l', Term.disable_mouse_all_motion)
    end

    SEQUENCES = %i(
      reset alt_screen exit_alt_screen clear_screen move_cursor hide_cursor
      show_cursor save_cursor_position restore_cursor_position cursor_up
      cursor_up cursor_down cursor_down cursor_forward cursor_forward cursor_back
      cursor_back cursor_next_line cursor_next_line cursor_prev_line
      cursor_prev_line clear_line clear_line_left clear_line_right clear_lines
      clear_lines scroll_up scroll_down change_scrolling_region insert_lines
      delete_lines enable_mouse_press disable_mouse_press enable_mouse
      disable_mouse enable_mouse_hilite disable_mouse_hilite
      enable_mouse_cell_motion disable_mouse_cell_motion enable_mouse_all_motion
      disable_mouse_all_motion
    )
    SEQUENCE_ARGS = {
      move_cursor: 2, cursor_up: 1, cursor_down: 1, cursor_forward: 1,
      cursor_back: 1, cursor_next_line: 1, cursor_prev_line: 1, scroll_up: 1,
      scroll_down: 1, change_scrolling_region: 2, clear_lines: 1,
      insert_lines: 1, delete_lines: 1,
    }

    def test_bang
      SEQUENCES.each do |seq|
        arity = SEQUENCE_ARGS.fetch(seq, 0)
        args = [8] * arity
        expected = Term.send(seq, *args)
        actual = capture_stdout { Term.send(:"#{seq}!", *args) }
        assert_equal(expected, actual)
      end
    end

    private

    def capture_stdout(&blk)
      io = StringIO.new
      begin
        prev = $stdout
        $stdout = io
        blk.call
      ensure
        $stdout = prev
      end
      io.rewind
      io.read
    end
  end
end

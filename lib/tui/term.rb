# typed: strict
# frozen_string_literal: true
require('tui')
require('io/console')

module TUI
  module Term
    extend(T::Sig)

    autoload(:ControlResponse, 'tui/term/control_response')
    autoload(:Query,           'tui/term/query')
    autoload(:Style,           'tui/term/style')

    ESC = "\x1b"
    CSI = T.let(ESC + '[', String)
    OSC = T.let(ESC + ']', String)
    BEL = "\a"
    OSC_QUERY_ARG = '?'
    SGR = 'm'

    OSC_WINDOW_TITLE_CODE         = 0
    OSC_COLOR_PALETTE_CODE        = 4
    OSC_NOTIFICATION_PALETTE_CODE = 9
    OSC_FOREGROUND_COLOR_CODE     = 10
    OSC_BACKGROUND_COLOR_CODE     = 11
    OSC_CURSOR_SHAPE_CODE         = 50
    OSC_CLIPBOARD_OPERATIONS_CODE = 52

    RESET_SEQ     = '0'
    BOLD_SEQ      = '1'
    FAINT_SEQ     = '2'
    ITALIC_SEQ    = '3'
    UNDERLINE_SEQ = '4'
    BLINK_SEQ     = '5'
    REVERSE_SEQ   = '7'
    CROSS_OUT_SEQ = '9'
    OVERLINE_SEQ  = '53'

    CURSOR_UP_SEQ               = '%dA'
    CURSOR_DOWN_SEQ             = '%dB'
    CURSOR_FORWARD_SEQ          = '%dC'
    CURSOR_BACK_SEQ             = '%dD'
    CURSOR_NEXT_LINE_SEQ        = '%dE'
    CURSOR_PREVIOUS_LINE_SEQ    = '%dF'
    CURSOR_HORIZONTAL_SEQ       = '%dG'
    CURSOR_POSITION_SEQ         = '%d;%dH'
    ERASE_DISPLAY_SEQ           = '%dJ'
    ERASE_LINE_SEQ              = '%dK'
    SCROLL_UP_SEQ               = '%dS'
    SCROLL_DOWN_SEQ             = '%dT'
    SAVE_CURSOR_POSITION_SEQ    = 's'
    RESTORE_CURSOR_POSITION_SEQ = 'u'
    CHANGE_SCROLLING_REGION_SEQ = '%d;%dr'
    INSERT_LINE_SEQ             = '%dL'
    DELETE_LINE_SEQ             = '%dM'

    # Explicit values for ERASE_LINE_SEQ
    ERASE_LINE_RIGHT_SEQ  = '0K'
    ERASE_LINE_LEFT_SEQ   = '1K'
    ERASE_ENTIRE_LINE_SEQ = '2K'

    SHOW_CURSOR_SEQ               = '?25h'
    HIDE_CURSOR_SEQ               = '?25l'
    ENABLE_MOUSE_PRESS_SEQ        = '?9h' # press only (X10)
    DISABLE_MOUSE_PRESS_SEQ       = '?9l'
    ENABLE_MOUSE_SEQ              = '?1000h' # press, release, wheel
    DISABLE_MOUSE_SEQ             = '?1000l'
    ENABLE_MOUSE_HILITE_SEQ       = '?1001h' # highlight
    DISABLE_MOUSE_HILITE_SEQ      = '?1001l'
    ENABLE_MOUSE_CELL_MOTION_SEQ  = '?1002h' # press, release, move on pressed, wheel
    DISABLE_MOUSE_CELL_MOTION_SEQ = '?1002l'
    ENABLE_MOUSE_ALL_MOTION_SEQ   = '?1003h' # press, release, move, wheel
    DISABLE_MOUSE_ALL_MOTION_SEQ  = '?1003l'
    ALT_SCREEN_SEQ                = '?1049h'
    EXIT_ALT_SCREEN_SEQ           = '?1049l'

    DEVICE_STATUS_REPORT_SEQ      = '6n'

    class << self
      extend(T::Sig)

      sig { returns(Color) }
      def foreground_color
        color = Query.osc(OSC_FOREGROUND_COLOR_CODE)
        Color.from_xterm(color)
      end

      sig { returns(Color) }
      def background_color
        color = Query.osc(OSC_BACKGROUND_COLOR_CODE)
        Color.from_xterm(color)
      end

      sig { returns([Integer, Integer]) }
      def cursor_position
        # raises if unable
        r, c = Query.dsr('R')
        # we could check that the length is 2 instead of leaning on sorbet-runtime
        [T.must(r), T.must(c)]
      end

      # rubocop:disable Style/SingleLineMethods

      # reset the terminal to its default style, removing any active styles.
      sig { void }
      def reset!; print(reset) end
      sig { returns(String) }
      def reset; CSI + RESET_SEQ + SGR end

      # switches to the alternate screen buffer. The former view can be
      # restored with ExitAltScreen.
      sig { void }
      def alt_screen!; print(alt_screen) end
      sig { returns(String) }
      def alt_screen; CSI + ALT_SCREEN_SEQ end

      # exits the alternate screen buffer and returns to the former terminal
      # view.
      sig { void }
      def exit_alt_screen!; print(exit_alt_screen) end
      sig { returns(String) }
      def exit_alt_screen; CSI + EXIT_ALT_SCREEN_SEQ end

      # clears the visible portion of the terminal.
      sig { void }
      def clear_screen!; print(clear_screen) end
      sig { returns(String) }
      def clear_screen; format(CSI + ERASE_DISPLAY_SEQ, 2) + move_cursor(1, 1) end

      sig { params(row: Integer, column: Integer).void }
      def move_cursor!(row, column); print(move_cursor(row, column)) end
      sig { params(row: Integer, column: Integer).returns(String) }
      def move_cursor(row, column); format(CSI + CURSOR_POSITION_SEQ, row, column) end

      sig { void }
      def hide_cursor!; print(hide_cursor) end
      sig { returns(String) }
      def hide_cursor; CSI + HIDE_CURSOR_SEQ end

      sig { void }
      def show_cursor!; print(show_cursor) end
      sig { returns(String) }
      def show_cursor; CSI + SHOW_CURSOR_SEQ end

      # tells the terminal to save the current cursor position internally, to
      # later be restored by restore_cursor_position
      sig { void }
      def save_cursor_position!; print(save_cursor_position) end
      sig { returns(String) }
      def save_cursor_position; CSI + SAVE_CURSOR_POSITION_SEQ end

      # restore the last cursor position saved by save_cursor_position
      sig { void }
      def restore_cursor_position!; print(restore_cursor_position) end
      sig { returns(String) }
      def restore_cursor_position; CSI + RESTORE_CURSOR_POSITION_SEQ end

      # moves the cursor up a given number of lines
      sig { params(n: Integer).void }
      def cursor_up!(n = 1); print(cursor_up(n)) end
      sig { params(n: Integer).returns(String) }
      def cursor_up(n = 1); format(CSI + CURSOR_UP_SEQ, n) end

      # moves the cursor down a given number of lines
      sig { params(n: Integer).void }
      def cursor_down!(n = 1); print(cursor_down(n)) end
      sig { params(n: Integer).returns(String) }
      def cursor_down(n = 1); format(CSI + CURSOR_DOWN_SEQ, n) end

      # moves the cursor forward a given number of cells
      sig { params(n: Integer).void }
      def cursor_forward!(n = 1); print(cursor_forward(n)) end
      sig { params(n: Integer).returns(String) }
      def cursor_forward(n = 1); format(CSI + CURSOR_FORWARD_SEQ, n) end

      # moves the cursor backwards a given number of cells
      sig { params(n: Integer).void }
      def cursor_back!(n = 1); print(cursor_back(n)) end
      sig { params(n: Integer).returns(String) }
      def cursor_back(n = 1); format(CSI + CURSOR_BACK_SEQ, n) end

      # moves the cursor down a given number of lines and places it at the
      # beginning of the line.
      sig { params(n: Integer).void }
      def cursor_next_line!(n = 1); print(cursor_next_line(n)) end
      sig { params(n: Integer).returns(String) }
      def cursor_next_line(n = 1); format(CSI + CURSOR_NEXT_LINE_SEQ, n) end

      # moves the cursor up a given number of lines and places it at the
      # beginning of the line.
      sig { params(n: Integer).void }
      def cursor_prev_line!(n = 1); print(cursor_prev_line(n)) end
      sig { params(n: Integer).returns(String) }
      def cursor_prev_line(n = 1); format(CSI + CURSOR_PREVIOUS_LINE_SEQ, n) end

      # clears the current line.
      sig { void }
      def clear_line!; print(clear_line) end
      sig { returns(String) }
      def clear_line; CSI + ERASE_ENTIRE_LINE_SEQ end

      # clears the line to the left of the cursor.
      sig { void }
      def clear_line_left!; print(clear_line_left) end
      sig { returns(String) }
      def clear_line_left; CSI + ERASE_LINE_LEFT_SEQ end

      # clears the line to the right of the cursor.
      sig { void }
      def clear_line_right!; print(clear_line_right) end
      sig { returns(String) }
      def clear_line_right; CSI + ERASE_LINE_RIGHT_SEQ end

      # clears a given number of lines.
      sig { params(n: Integer).void }
      def clear_lines!(n = 1); print(clear_lines(n)) end
      sig { params(n: Integer).returns(String) }
      def clear_lines(n = 1)
        clear_line = format(CSI + ERASE_LINE_SEQ, 2)
        cursor_up = format(CSI + CURSOR_UP_SEQ, 1)
        clear_line + (cursor_up + clear_line) * n
      end

      sig { params(n: Integer).void }
      def scroll_up!(n = 1); print(scroll_up(n)) end
      sig { params(n: Integer).returns(String) }
      def scroll_up(n = 1); format(CSI + SCROLL_UP_SEQ, n) end

      sig { params(n: Integer).void }
      def scroll_down!(n = 1); print(scroll_down(n)) end
      sig { params(n: Integer).returns(String) }
      def scroll_down(n = 1); format(CSI + SCROLL_DOWN_SEQ, n) end

      # sets the scrolling region of the terminal.
      sig { params(top: Integer, bottom: Integer).void }
      def change_scrolling_region!(top, bottom); print(change_scrolling_region(top, bottom)) end
      sig { params(top: Integer, bottom: Integer).returns(String) }
      def change_scrolling_region(top, bottom); format(CSI + CHANGE_SCROLLING_REGION_SEQ, top, bottom) end

      # inserts the given number of lines at the top of the scrollable region,
      # pushing lines below down.
      sig { params(n: Integer).void }
      def insert_lines!(n); print(insert_lines(n)) end
      sig { params(n: Integer).returns(String) }
      def insert_lines(n); format(CSI + INSERT_LINE_SEQ, n) end

      # deletes the given number of lines, pulling any lines in the scrollable
      # region below up.
      sig { params(n: Integer).void }
      def delete_lines!(n); print(delete_lines(n)) end
      sig { params(n: Integer).returns(String) }
      def delete_lines(n); format(CSI + DELETE_LINE_SEQ, n) end

      # enables X10 mouse mode. Button press events are sent only.
      sig { void }
      def enable_mouse_press!; print(enable_mouse_press) end
      sig { returns(String) }
      def enable_mouse_press; CSI + ENABLE_MOUSE_PRESS_SEQ end

      # disables X10 mouse mode.
      sig { void }
      def disable_mouse_press!; print(disable_mouse_press) end
      sig { returns(String) }
      def disable_mouse_press; CSI + DISABLE_MOUSE_PRESS_SEQ end

      # enables Mouse Tracking mode.
      sig { void }
      def enable_mouse!; print(enable_mouse) end
      sig { returns(String) }
      def enable_mouse; CSI + ENABLE_MOUSE_SEQ end

      # disables Mouse Tracking mode.
      sig { void }
      def disable_mouse!; print(disable_mouse) end
      sig { returns(String) }
      def disable_mouse; CSI + DISABLE_MOUSE_SEQ end

      # enables Hilite Mouse Tracking mode.
      sig { void }
      def enable_mouse_hilite!; print(enable_mouse_hilite) end
      sig { returns(String) }
      def enable_mouse_hilite; CSI + ENABLE_MOUSE_HILITE_SEQ end

      # disables Hilite Mouse Tracking mode.
      sig { void }
      def disable_mouse_hilite!; print(disable_mouse_hilite) end
      sig { returns(String) }
      def disable_mouse_hilite; CSI + DISABLE_MOUSE_HILITE_SEQ end

      # enables Cell Motion Mouse Tracking mode.
      sig { void }
      def enable_mouse_cell_motion!; print(enable_mouse_cell_motion) end
      sig { returns(String) }
      def enable_mouse_cell_motion; CSI + ENABLE_MOUSE_CELL_MOTION_SEQ end

      # disables Cell Motion Mouse Tracking mode.
      sig { void }
      def disable_mouse_cell_motion!; print(disable_mouse_cell_motion) end
      sig { returns(String) }
      def disable_mouse_cell_motion; CSI + DISABLE_MOUSE_CELL_MOTION_SEQ end

      # enables All Motion Mouse mode.
      sig { void }
      def enable_mouse_all_motion!; print(enable_mouse_all_motion) end
      sig { returns(String) }
      def enable_mouse_all_motion; CSI + ENABLE_MOUSE_ALL_MOTION_SEQ end

      # disables All Motion Mouse mode.
      sig { void }
      def disable_mouse_all_motion!; print(disable_mouse_all_motion) end
      sig { returns(String) }
      def disable_mouse_all_motion; CSI + DISABLE_MOUSE_ALL_MOTION_SEQ end

      # rubocop:enable Style/SingleLineMethods
    end
  end
end

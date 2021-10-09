$:.unshift(File.expand_path('../lib', __dir__))
require('tui')

# In real life situations we'd adjust the document to fit the width we've
# detected. In the case of this example we're hardcoding the width, and
# later using the detected width only to truncate in order to avoid jaggy
# wrapping.
WIDTH = 96
COLUMN_WIDTH = 30

SUBTLE    = TUI::Color::Adaptive.new(light: TUI::Color["#D9DCCF"], dark: TUI::Color["#383838"])
HIGHLIGHT = TUI::Color::Adaptive.new(light: TUI::Color["#874BFD"], dark: TUI::Color["#7D56F4"])
SPECIAL   = TUI::Color::Adaptive.new(light: TUI::Color["#43BF6D"], dark: TUI::Color["#73F59F"])

# divider = lipgloss.NewStyle().
#   SetString("•").
#   Padding(0, 1).
#   Foreground(subtle).
#   String()

# url = lipgloss.NewStyle().Foreground(special).Render

ACTIVE_TAB_BORDER = TUI::Border.new(
  top:          "─",
  bottom:       " ",
  left:         "│",
  right:        "│",
  top_left:     "╭",
  top_right:    "╮",
  bottom_left:  "┘",
  bottom_right: "└",
)


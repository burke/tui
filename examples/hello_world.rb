$:.unshift(File.expand_path('../lib', __dir__))
require('tui')

p = TUI::ColorProfile.detect

print("\n\t")
print(%i(bold faint italic underline cross_out).map do |attr|
  TUI::Term::Style.new(attr => true).render(attr.to_s)
end.join(' '))

colors = {
  red:     "#E88388",
  green:   "#A8CC8C",
  yellow:  "#DBAB79",
  blue:    "#71BEF2",
  magenta: "#D290E4",
  cyan:    "#66C2CD",
  gray:    "#B9BFCA",
}

print("\n\t")
print(colors.map do |name, hex|
  TUI::Term::Style.new(foreground: p.color(hex)).render(name.to_s)
end.join(' '))

print("\n\t")
black = p.color('0')
print(colors.map do |name, hex|
  TUI::Term::Style.new(foreground: black, background: p.color(hex)).render(name.to_s)
end.join(' '))

print("\n\n")

bold = TUI::Term::Style.new(bold: true)
puts("\t#{bold.render('Has foreground color')} #{TUI::Term.foreground_color.hex}")
puts("\t#{bold.render('Has background color')} #{TUI::Term.background_color.hex}")
puts("\t#{bold.render('Has dark background?')} #{TUI::Term.dark_background?}")

$:.unshift(File.expand_path('../lib', __dir__))
require('tui')

# Basic ANSI colors 0 - 15
puts(TUI::Term::Style.new(bold: true).render("Basic ANSI colors"))

p = TUI::Profile::ANSI

16.times do |i|
  puts if i%8 == 0

  # background color
  bg = p.color(i.to_s)
  out = format(' %2d %s ', i, bg.hex)

  style = if i < 5
    TUI::Term::Style.new(foreground: p.color('7'))
  else
    TUI::Term::Style.new(foreground: p.color('0'))
  end
  style = style.extend(background: bg)

  print(style.render(out))
end

print("\n\n")

# Extended ANSI colors 16-231
puts(TUI::Term::Style.new(bold: true).render("Extended ANSI colors"))

p = TUI::Profile::ANSI256
(16...232).each do |i|
  puts if (i-16)%6 == 0

  # background color
  bg = p.color(i.to_s)
  out = format(' %3d %s ', i, bg.hex)

  # apply colors
  style = if i < 28
    TUI::Term::Style.new(foreground: p.color('7'))
  else
    TUI::Term::Style.new(foreground: p.color('0'))
  end
  style = style.extend(background: bg)

  print(style.render(out))
end

print("\n\n")

# Grayscale ANSI colors 232-255
puts(TUI::Term::Style.new(bold: true).render("Extended ANSI Grayscale"))

p = TUI::Profile::ANSI256
(232...256).each do |i|
  puts if (i-232)%6 == 0

  # background color
  bg = p.color(i.to_s)
  out = format(' %3d %s ', i, bg.hex)

  # apply colors
  style = if i < 244
    TUI::Term::Style.new(foreground: p.color('7'))
  else
    TUI::Term::Style.new(foreground: p.color('0'))
  end
  style = style.extend(background: bg)

  print(style.render(out))
end

print("\n\n")

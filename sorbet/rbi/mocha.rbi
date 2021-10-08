# wonder if there's some way to to make this only happen in test mode.
class Object
  def expects(*); end
  def stubs(*); end
end

class Minitest::Test
  def mock(*); end
end

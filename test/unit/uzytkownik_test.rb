require 'test_helper'

class UzytkownikTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Uzytkownik.new.valid?
  end
end

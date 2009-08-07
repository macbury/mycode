require 'test_helper'

class ZnajomoscTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Znajomosc.new.valid?
  end
end

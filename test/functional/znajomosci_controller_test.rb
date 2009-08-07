require 'test_helper'

class ZnajomosciControllerTest < ActionController::TestCase
  def test_create_invalid
    Znajomosc.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Znajomosc.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to root_url
  end
  
  def test_destroy
    znajomosc = Znajomosc.first
    delete :destroy, :id => znajomosc
    assert_redirected_to root_url
    assert !Znajomosc.exists?(znajomosc.id)
  end
end

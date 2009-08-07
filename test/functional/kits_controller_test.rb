require 'test_helper'

class KitsControllerTest < ActionController::TestCase
  def test_create_invalid
    Kit.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Kit.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to root_url
  end
  
  def test_destroy
    kit = Kit.first
    delete :destroy, :id => kit
    assert_redirected_to root_url
    assert !Kit.exists?(kit.id)
  end
end

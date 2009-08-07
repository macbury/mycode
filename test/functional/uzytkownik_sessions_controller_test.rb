require 'test_helper'

class UzytkownikSessionsControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    UzytkownikSession.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    UzytkownikSession.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to root_url
  end
  
  def test_destroy
    uzytkownik_session = UzytkownikSession.first
    delete :destroy, :id => uzytkownik_session
    assert_redirected_to root_url
    assert !UzytkownikSession.exists?(uzytkownik_session.id)
  end
end

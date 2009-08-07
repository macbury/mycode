require 'test_helper'

class UzytkownicyControllerTest < ActionController::TestCase
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Uzytkownik.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Uzytkownik.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to uzytkownik_url(assigns(:uzytkownik))
  end
  
  def test_edit
    get :edit, :id => Uzytkownik.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Uzytkownik.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Uzytkownik.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Uzytkownik.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Uzytkownik.first
    assert_redirected_to uzytkownik_url(assigns(:uzytkownik))
  end
  
  def test_show
    get :show, :id => Uzytkownik.first
    assert_template 'show'
  end
end

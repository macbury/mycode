class UzytkownikSessionsController < ApplicationController
  tab :logowanie
  
  def new
    @uzytkownik_session = UzytkownikSession.new
  end
  
  def create
    @uzytkownik_session = UzytkownikSession.new(params[:uzytkownik_session])
    if @uzytkownik_session.save
      flash[:notice] = "Zostałeś zalogowany w serwisie"
      redirect_back_or_default(profil_path(@uzytkownik_session.login))
    else
      flash[:error] = "Nieprawidłowe hasło lub login"
      render :action => "new"
    end
  end
  
  def destroy
    @uzytkownik_session = UzytkownikSession.find
    @uzytkownik_session.destroy if @uzytkownik_session
    flash[:notice] = "Zostałeś wylogowany z serwisu!"
    redirect_to root_url
  end
end

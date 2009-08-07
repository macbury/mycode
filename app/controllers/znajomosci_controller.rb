class ZnajomosciController < ApplicationController
  before_filter :login_required
  
  def create
    @uzytkownik = Uzytkownik.find(params[:znajomy_id])
    
    if @uzytkownik
      self.current_uzytkownik.znajomosci.find_or_create_by_znajomy_id(@uzytkownik.id)
      flash[:notice] = "Zaczynasz obserwować tego użytkownika"
    else
      flash[:error] = "Nie można obserwować tego użytkownika"
    end
    
    redirect_to profil_path(self.current_uzytkownik)
  end
  
  def destroy
    @znajomosc = self.current_uzytkownik.znajomosci.find_by_znajomy_id(params[:id])
    @znajomosc.destroy
    flash[:notice] = "Przestajesz obserwować tego użytkownika."
    redirect_to profil_path(self.current_uzytkownik)
  end
end

class UzytkownicyController < ApplicationController
  before_filter :login_required, :only => [:edit, :update]
  tab :ustawienia, :only => [:edit, :update]
  tab :rejestracja, :only => [:new, :create]
  
  def new
    @uzytkownik = Uzytkownik.new
  end
  
  def create
    @uzytkownik = Uzytkownik.new(params[:uzytkownik])
    if @uzytkownik.save_without_session_maintenance
      flash[:notice] = "Rejestracja przebiegła pomyślnie! Na twój email został wysłane link aktywacyjny"
      @uzytkownik.deliver_activation
      redirect_to root_path
    else
      render :action => 'new'
    end
  end
  
  def edit
    @title = 'ustawienia'
    @uzytkownik = self.current_uzytkownik
  end
  
  def update
    @uzytkownik = self.current_uzytkownik
    if @uzytkownik.update_attributes(params[:uzytkownik])
      flash[:notice] = "Zmieniono ustawienia."
      redirect_to edit_uzytkownik_path(@uzytkownik)
    else
      render :action => 'edit'
    end
  end
  
  def show
    @uzytkownik = Uzytkownik.find_by_login(params[:login])
    redirect_to uzytkownik_statuses_path(@uzytkownik.login)
  end
  
  def activate
    @uzytkownik = Uzytkownik.find_using_perishable_token(params[:id], 1.week)
    if @uzytkownik.nil?
      flash[:error] = 'Nieprawidłowy kod aktywacyjny!'
      redirect_to root_path
    elsif @uzytkownik.active?
      flash[:error] = 'Konto jest już aktywne!'
      redirect_to root_path
    else
      @uzytkownik.active!
      flash[:notice] = 'Konto aktywowane! Możesz się już zalogować!'
      redirect_to login_path
    end
    
  end
end

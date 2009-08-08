# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_uzytkownik, :logged_in?, :current_session
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation
  
  protected

  def self.tab(name, options = {})
    before_filter(options) do |controller|
      controller.instance_variable_set('@current_tab', name)
    end
  end

  def self.title(name, options = {})
    before_filter(options) do |controller|
      controller.instance_variable_set('@title', name)
    end
  end

  def self.sub_tab(name, options = {})
    before_filter(options) do |controller|
      controller.instance_variable_set('@sub_tab', name)
    end
  end

  def current_session
    @current_session ||= UzytkownikSession.find
    return @current_session
  end

  def current_uzytkownik
    return @current_uzytkownik if defined?(@current_uzytkownik)
    @current_uzytkownik = current_session && current_session.record
  end
  
  def logged_in?
    current_uzytkownik
  end
  
  def login_required
    unless logged_in?
      store_location
      flash[:notice] = "Musisz być zalogowany aby mieć dostęp do tej części serwisu"
      redirect_to login_path
      return false
    end
  end
  
  def store_location
    session[:return_to] = request.request_uri
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def get_uzytkownik
    if params[:uzytkownik_id]
      @uzytkownik = Uzytkownik.find_by_login(params[:uzytkownik_id])
    elsif logged_in?
      @uzytkownik = @current_uzytkownik
    end
    
    if logged_in? && !@uzytkownik.nil? && @uzytkownik.id == @current_uzytkownik.id
      @current_tab = :profil
    end
    
    if @uzytkownik.nil?
      render :file => "#{RAILS_ROOT}/public/404.html"
    else
      @title = @uzytkownik.login
    end
    
  end
end

class StaticController < ApplicationController
  tab :home
  title 'strona główna'
  
  def index
    @statusy = Status.paginate :order => 'created_at DESC', :per_page => 10, :page => params[:page], :include => [:uzytkownik, :statusable]
    @grupy_statusow = @statusy.group_by { |status| status.created_at.to_date }
  end
end

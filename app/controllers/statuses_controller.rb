class StatusesController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :archiwum]
  before_filter :get_uzytkownik, :only => [:index, :show, :archiwum]
  before_filter :prepare_conditions, :only => [:index, :show, :archiwum]
  
  sub_tab :wiadomosci
  def index
    
    if params[:time]
      time = params[:time].to_time.utc
      @conditions[0] += ' AND statuses.created_at > ?'
      @conditions << time
    end
    
    @statusy = Status.all(:conditions => @conditions, :include => [:uzytkownik, :statusable], :order => 'statuses.created_at DESC', :limit => 10)
    
    if @statusy.size > 0
      @time = @statusy.map(&:created_at).max
    elsif params[:time]
      @time = params[:time].to_time
    else
      @time = Time.current
    end
    
    if logged_in? && self.current_uzytkownik.id != @uzytkownik.id
      @message = "@#{@uzytkownik.login} "
    else
      @message = ''
    end
    
    @grupy_statusow = @statusy.group_by { |status| status.created_at.to_date }
    
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @statusy }
      format.json { render :json => @statusy }
    end
  end
  
  def archiwum
    time = params[:time].to_time.utc
    @conditions[0] += ' AND statuses.created_at < ?'
    @conditions << time
    
    @statusy = Status.all(:conditions => @conditions, :include => [:uzytkownik], :order => 'statuses.created_at DESC', :limit => 10)
    
    respond_to do |format|
      format.js
      format.html { redirect_to root_path }
    end
  end
  
  def show
    redirect_to root_path
  end

  # POST /statuses
  # POST /statuses.xml
  def create
    @status = self.current_uzytkownik.statuses.new(params[:status])
    respond_to do |format|
      if @status.save
        flash[:notice] = 'Status został dodany!'
        format.html { redirect_to profil_path(@uzytkownik.login) }
        format.js
        format.xml  { render :xml => @status, :status => :created, :location => @status }
      else
        flash[:notice] = 'Nie można dodać statusu!'
        format.html { render :action => "new" }
        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.xml
#  def update
#    @status = Status.find(params[:id])

#    respond_to do |format|
#      if @status.update_attributes(params[:status])
#        flash[:notice] = 'Status was successfully updated.'
#        format.html { redirect_to(@status) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @status.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /statuses/1
  # DELETE /statuses/1.xml
  def destroy
    @status = @current_uzytkownik.statuses.find(params[:id])
    @status.destroy

    respond_to do |format|
      format.html { redirect_to(statuses_path) }
      format.xml  { head :ok }
      format.js { render :nothing => true }
    end
  end

  protected
    def prepare_conditions
      uzytkownicy = @uzytkownik.znajomosci.all(:select => 'znajomy_id').map(&:znajomy_id)
      uzytkownicy << @uzytkownik.id
      
      obserwowane = Status.all(:select => 'statusable_id', :conditions => ['statusable_type IS NOT NULL AND uzytkownik_id = ?', @uzytkownik.id], :group => 'statusable_type' ).map(&:statusable_id)
      
      @conditions = ['(uzytkownik_id IN (?) OR odbiorca_id = ? OR statusable_id IN (?))', uzytkownicy, @uzytkownik.id, obserwowane]
    end
end

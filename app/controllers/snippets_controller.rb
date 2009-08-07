class SnippetsController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :public]
  before_filter :get_uzytkownik, :except => [:show, :public]
  before_filter :prepare_conditions, :only => [:index, :public]
  
  tab :snippets, :only => [:public, :show]
  sub_tab :snippets
  
  def public
    @snippets = Snippet.paginate(:order => @order, :page => params[:page], :per_page => 5, :conditions => @conditions)
    
    respond_to do |format|
      format.html
      format.js { render :action => "index" }
    end
  end
  
  # GET /snippets
  # GET /snippets.xml
  def index
    @snippets = @uzytkownik.snippets.paginate(:order => @order, :page => params[:page], :per_page => 5, :conditions => @conditions)
    @languages = @uzytkownik.snippets.all(:select => 'snippets.language', :group => 'snippets.language', :order => 'snippets.language', :conditions => 'snippets.language IS NOT NULL').map(&:language)
    
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @snippets }
    end
  end

  # GET /snippets/1
  # GET /snippets/1.xml
  def show
    @snippet = Snippet.find(params[:id])
    @uzytkownik = @snippet.uzytkownik
    
    @statusy = @snippet.statuses.all(:include => [:uzytkownik], :order => 'created_at  DESC')
    @grupy_statusow = @statusy.group_by { |status| status.created_at.to_date }
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @snippet }
    end
  end

  # GET /snippets/new
  # GET /snippets/new.xml
  def new
    @snippet = Snippet.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @snippet }
    end
  end

  # GET /snippets/1/edit
  def edit
    @snippet = Snippet.find(params[:id])
    if self.current_uzytkownik.own?(@snippet)
      render :action => "new"
    else
      redirect_to snippets_path
    end
  end

  # POST /snippets
  # POST /snippets.xml
  def create
    @snippet = self.current_uzytkownik.snippets.new(params[:snippet])

    respond_to do |format|
      if @snippet.save
        flash[:notice] = 'Dodano nowy kawałek kodu'
        format.html { redirect_to(@snippet) }
        format.xml  { render :xml => @snippet, :status => :created, :location => @snippet }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @snippet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /snippets/1
  # PUT /snippets/1.xml
  def update
    @snippet = Snippet.find(params[:id])
    redirect_to snippets_path and return unless self.current_uzytkownik.own?(@snippet)
      
    respond_to do |format|
      if @snippet.update_attributes(params[:snippet])
        flash[:notice] = 'Kod został zaktualizowany!.'
        format.html { redirect_to(@snippet) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @snippet.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /snippets/1
  # DELETE /snippets/1.xml
  def destroy
    flash[:notice] = 'Usunięto kawałek kodu'
    @snippet = self.current_uzytkownik.snippets.find(params[:id])
    @snippet.destroy

    respond_to do |format|
      format.html { redirect_to(uzytkownik_snippets_path(self.current_uzytkownik)) }
      format.xml  { head :ok }
    end
  end
  
  protected
    def prepare_conditions
      @conditions = {}

      if params[:sortowanie].to_i == 1
        @order = 'snippets.created_at DESC'
      else
        @order = 'snippets.name' 
      end

      if params[:keyword] && params[:keyword].size > 1
        @conditions[:name.like] = "%#{params[:keyword]}%" 
      end
      @conditions[:language] = params[:language] if params[:language] && params[:language].to_i != -1
    end
end

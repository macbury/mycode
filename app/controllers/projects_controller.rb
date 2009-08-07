class ProjectsController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :public, :latest]
  before_filter :get_uzytkownik, :except => [:show, :public, :latest]
  before_filter :prepare_conditions, :only => [:index, :public, :latest]
  
  tab :projects, :only => [:public, :show]
  sub_tab :projects

  def latest
    request.format = :rss
    @projects = Project.all(:order => 'created_at DESC', :limit => 10)
  end

  def public
    conditions = {}
    order = case params[:sortowanie].to_i
      when 1 then 'projects.created_at DESC'
      else 'projects.name' 
    end
    
    if params[:keyword] && params[:keyword].size > 1
      conditions[:name.like] = "%#{params[:keyword]}%"
    end 
    
    @projects = Project.paginate :per_page => 10, :page => params[:page], :conditions => conditions, :order => order
    
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # GET /projects
  # GET /projects.xml
  def index
    @projects = @uzytkownik.projects.paginate :per_page => 10, :page => params[:page]

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @projects }
    end
  end

  # GET /projects/1
  # GET /projects/1.xml
  def show
    @project = Project.find(params[:id])
    @uzytkownik = @project.uzytkownik
    
    @statusy = @project.statuses.all(:include => [:uzytkownik], :order => 'created_at  DESC')
    @grupy_statusow = @statusy.group_by { |status| status.created_at.to_date }
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/new
  # GET /projects/new.xml
  def new
    @project = Project.new
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @project }
    end
  end

  # GET /projects/1/edit
  def edit
    @project = self.current_uzytkownik.projects.find(params[:id])
    render :action => "new"
  end

  # POST /projects
  # POST /projects.xml
  def create
    @project = self.current_uzytkownik.projects.new(params[:project])

    respond_to do |format|
      if @project.save
        flash[:notice] = 'Projekt został dodany.'
        format.html { redirect_to(@project) }
        format.xml  { render :xml => @project, :status => :created, :location => @project }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /projects/1
  # PUT /projects/1.xml
  def update
    @project = self.current_uzytkownik.projects.find(params[:id])

    respond_to do |format|
      if @project.update_attributes(params[:project])
        flash[:notice] = 'Projekt zostal zapisany.'
        format.html { redirect_to(@project) }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @project.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.xml
  def destroy
    @project = self.current_uzytkownik.projects.find(params[:id])
    @project.destroy

    respond_to do |format|
      format.html { redirect_to(uzytkownik_projects_path(self.current_uzytkownik)) }
      format.xml  { head :ok }
    end
  end
  
  protected
    def prepare_conditions
      @conditions = {}

      if params[:sortowanie].to_i == 1
        @order = 'projects.created_at DESC'
      else
        @order = 'projects.name' 
      end

      if params[:keyword] && params[:keyword].size > 1
        @conditions[:name.like] = "%#{params[:keyword]}%" 
      end
      @conditions[:language] = params[:language] if params[:language] && params[:language].to_i != -1
    end
end

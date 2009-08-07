class ToolsController < ApplicationController
  before_filter :login_required, :except => [:index, :show, :suggest, :latest]
  before_filter :get_uzytkownik, :except => [:index, :show, :suggest, :latest]
  tab :tools, :only => [:index, :show]
  sub_tab :tools
  title 'narzędzia'
  
  def latest
    request.format = :rss
    @tools = Tool.all(:order => 'created_at DESC', :limit => 10)
  end
  
  
  def suggest
    @tools = Tool.all( :conditions => { :name.like => "%#{params[:tag]}%" }, :limit => 5 )
    
    render :json => @tools.map { |tool| { :caption => tool.name, :value => tool.id } }
  end
  
  # GET /tools
  # GET /tools.xml
  def index
    conditions = {}
    
    order = case params[:sortowanie].to_i
      when 1 then 'tools.kits_count'
      when 2 then 'tools.created_at DESC'
      else 'tools.name' 
    end
    
    conditions[:name.like] = "%#{params[:keyword]}%" if params[:keyword] && params[:keyword].size > 1
    conditions[:typ] = params[:typ] if params[:typ] && params[:typ].to_i != -1
    conditions[:language] = params[:language] if params[:language] && params[:language].to_i != -1
    
    @tools = Tool.paginate(:conditions => conditions, :order => order, :per_page => 10, :page => params[:page])

    #@grupped_tools = @tools.group_by(&:typ)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tools }
      format.js
    end
  end

  # GET /tools/1
  # GET /tools/1.xml
  def show
    get_uzytkownik if logged_in?
    @tool = Tool.first(:conditions => ['id = ? OR name LIKE ?',params[:id],"%#{params[:id]}%"])
    @title = @tool.name
    
    @statusy = @tool.statuses.all(:include => [:uzytkownik], :order => 'created_at  DESC')
    @grupy_statusow = @statusy.group_by { |status| status.created_at.to_date }
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tool }
    end
  end
  
  def search
    if params[:name]
      @tools = Tool.all(:conditions => { :name.like => "%#{params[:name]}%" }, :limit => 10)
    end
    
    respond_to do |format|
      format.js
      format.html
    end
  end
  
  # GET /tools/new
  # GET /tools/new.xml
  def new
    @tool = Tool.new
    @tool.name = params[:name] if params[:name]
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tool }
    end
  end

  def edit
    @tool = Tool.find(params[:id])
    render :action => "new"
  end

  # POST /tools
  # POST /tools.xml
  def create
    @tool = Tool.new(params[:tool])

    respond_to do |format|
      if @tool.save
        @current_uzytkownik.addToKit(@tool)
        flash[:notice] = 'Narzędzie zostało dodane'
        format.html { redirect_to(@tool) }
        format.xml  { render :xml => @tool, :status => :created, :location => @tool }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @tool.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tools/1
  # PUT /tools/1.xml
  #def update
  #  @tool = Tool.find(params[:id])
  #
  #  respond_to do |format|
  #    if @tool.update_attributes(params[:tool])
  #      flash[:notice] = 'Tool was successfully updated.'
  #      format.html { redirect_to(@tool) }
  #      format.xml  { head :ok }
  #    else
  #      format.html { render :action => "edit" }
  #      format.xml  { render :xml => @tool.errors, :status => :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /tools/1
  # DELETE /tools/1.xml
  #def destroy
  #  @tool = Tool.find(params[:id])
  #  @tool.destroy

#    respond_to do |format|
#      format.html { redirect_to(tools_url) }
#      format.xml  { head :ok }
#    end
#  end
end

class KitsController < ApplicationController
  before_filter :login_required, :only => [:create, :destroy]
  before_filter :get_uzytkownik, :only => [:index, :show]
  
  tab :profil
  sub_tab :tools
  
  def index
    conditions = {}
    
    if params[:sortowanie].to_i == 1
      order = 'tools.created_at DESC'
    else
      order = 'tools.name' 
    end
    
    conditions[:name.like] = "%#{params[:keyword]}%" if params[:keyword] && params[:keyword].size > 1
    conditions[:typ] = params[:typ] if params[:typ] && params[:typ].to_i != -1
    conditions[:language] = params[:language] if params[:language] && params[:language].to_i != -1
    
    @tools = @uzytkownik.tools.paginate(:order => order, :conditions => conditions, :per_page => 10, :page => params[:page], :group => 'kits.tool_id')
    
    @languages = @uzytkownik.tools.all(:select => 'tools.language', :group => 'tools.language', :order => 'tools.language', :conditions => 'tools.language IS NOT NULL').map(&:language)
    @typy = @uzytkownik.tools.all(:select => 'tools.typ', :group => 'tools.typ', :order => 'tools.typ', :conditions => 'tools.typ IS NOT NULL').map(&:typ)
    
    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @tools }
    end
  end
  
  def show
    @tool = self.current_uzytkownik.tools.find(params[:id])
    
    render :action => '../tools/show'
  end
  
  def create
    @tool = Tool.find(params[:tool_id])
    self.current_uzytkownik.addToKit(@tool)
    flash[:notice] = "Narzędzie zostało dodane do mojej listy!"
    redirect_to @tool
  end
  
  def destroy
    @tool = self.current_uzytkownik.tools.find(params[:id])
    @kit = self.current_uzytkownik.kits.find_by_tool_id(@tool.id)
    @kit.destroy
    flash[:notice] = "Narzędzie zostało usunięte z mojej listy!"
    redirect_to @tool
  end
end

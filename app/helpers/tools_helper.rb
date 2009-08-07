module ToolsHelper
  
  def filter_for(param, tab, default, name)
    selected = params[param] || default
    content_tag :li, link_to(name, "##{param.to_s}_#{tab}"), :class => selected.to_i == tab.to_i ? 'selected' : 'normal'
  end
  
end

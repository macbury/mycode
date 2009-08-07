# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def error_for(object, key)
    errors = object.errors.on(key)
    
    unless errors.nil?
      if errors.class == Array
        error_string = errors.join(', ')
      else
        error_string = errors
      end
      return content_tag(:span, " - #{error_string}", :class => 'errors')
    end

  end
  
  def tag_for(tab, name, link, icon)
    content_tag :li, link_to(name, link, :class => icon), :class => @current_tab == tab ? 'selected' : 'normal'
  end
  
  def sub_tab_for(tab, name, link, icon)
    content_tag :li, link_to(name, link, :class => icon), :class => @sub_tab == tab ? 'selected' : 'normal'
  end

  def render_title
    main = 'my-code.pl'
    main += " - #{@title}" unless @title.nil?
    return main
  end
  
  #		<link rel="alternate" type="application/rss+xml" title="Najnowsze narzędzia" href="<%= latest_tools_path %>" />
  def rss_link(title, path)
    tag :link, :type => 'application/rss+xml', :title => title, :href => path
  end
end

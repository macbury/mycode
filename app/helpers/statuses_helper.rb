module StatusesHelper
  
  def day_title(dzien)
    if dzien.to_date == Date.current
      'Dzisiaj'
    elsif dzien.to_date == (1.day.ago.to_date)
      'Wczoraj'
    else
      I18n.l dzien.to_date, :format => :long
    end
  end
  
  def parse(message)
    html = message
    #html.gsub!(/&([a-z\_\+\-A-Z0-9]+)/i, '<a href="/tools/\\1" class="plugin">\\1</a>')
    #html.gsub!(/#([0-9]+)/, '<a href="/snippets/\\1" class="snippet">#\\1</a>')
    return html
  end
  
  def status_title(status)
    out = ''
    out += link_to status.uzytkownik.login, profil_path(status.uzytkownik.login)
    
    if !status.statusable.nil?
      out += ' > '
      out += case status.statusable_type
        when 'Snippet' then link_to "##{status.statusable.name}", status.statusable, :class => 'snippet'
        when 'Tool' then link_to "##{status.statusable.name}", status.statusable, :class => 'plugin'
        when 'Project' then link_to "&#{status.statusable.name}", status.statusable, :class => 'project'
      end
    elsif status.odbiorca_id
      out += ' > '
      out += link_to status.odbiorca.login, profil_path(status.odbiorca.login)
    end
    
    return out
  end
  
end

xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Aktywności użytkownika #{@uzytkownik.login}"
    xml.link profil_url(@uzytkownik)
    
    for status in @statusy
      xml.item do
        xml.title status_title_rss(status)
        xml.description status.message
        xml.pubDate status.created_at.to_s(:rfc822)
        xml.link status_url(status)
        xml.guid status_url(status)
      end
    end
  end
end
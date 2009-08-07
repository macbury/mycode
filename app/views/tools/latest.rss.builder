xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'Ostatnio dodane narzędzia'
    xml.link tools_url
    
    for tool in @tools
      xml.item do
        xml.title tool.name
        xml.description tool.description
        xml.pubDate tool.created_at.to_s(:rfc822)
        xml.link tool_url(tool)
        xml.guid tool_url(tool)
      end
    end
  end
end
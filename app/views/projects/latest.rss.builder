xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title 'Ostatnio dodane projekty'
    xml.link projects_path
    
    for project in @projects
      xml.item do
        xml.title project.name
        xml.description project.description
        xml.pubDate project.created_at.to_s(:rfc822)
        xml.link project_url(project)
        xml.guid project_url(project)
      end
    end
  end
end
class CumulusMetaDatastream < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(path: "fields")
    t.title(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],:path=>"title", :label=>"Title")
    #t.title(index_as: [:searchable, :displayable, :sortable])
    t.author(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>"author", :label=>"Author")
    #t.author(index_as: [:searchable, :facetable, :displayable, :sortable])
    t.category(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>"category", :label=>"Category")
    #t.category(index_as: [:searchable, :facetable, :displayable])
    t.date_start
    t.date_end
    t.description(:type => :text, :index_as=>[:stored_searchable, :displayable],:path=>"description", :label=>"Description")
    #t.description(index_as: [:searchable, :displayable ])
    t.fileidentifier(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>"fileidentifier", :label=>"Fileidentifier")
    #t.fileidentifier(index_as: [:searchable, :displayable, :sortable])
    t.geo_lat
    t.geo_lng
    t.imagetype(:index_as=>[:facetable],:path=>{:attribute=>"imagetype"}, :label=>"Imagetype")
    #t.imagetype(:type => :string, :index_as=>[:facetable, :stored_searchable, :displayable, :sortable, ],:path=>"imagetype", :label=>"imagetype")
    t.local
    t.path_to_image(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>"pathtoimage", :label=>"pathtoimage")
  end


  def self.xml_template
    Nokogiri::XML.parse("<fields/>")
  end
end
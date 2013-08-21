class CumulusMetaDatastream < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(path: 'fields')
    t.title(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],:path=>'title', :label=>'Title')
    #t.title(index_as: [:searchable, :displayable, :sortable])
    t.author(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>'author', :label=>'Author')
    t.person(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>'person', :label=>'Person')
    #t.author(index_as: [:searchable, :facetable, :displayable, :sortable])
    t.category(:type => :text, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>'category', :label=>'Category')
    t.genre(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>'genre', :label=>'Genre')
    t.copyright(:type => :string, :index_as => [:stored_searchable, :displayable, :sortable, :facetable], :path => 'copyright', :label => 'Copyright')
    #t.category(index_as: [:searchable, :facetable, :displayable])
    t.date_start(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>'date_start', :label=>'date_start')
    t.date_end
    t.date_txt
    t.description(:type => :text, :index_as=>[:stored_searchable, :displayable],:path=>'description', :label=>'Description')
    t.lcsh(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>'lcsh', :label=>'lcsh')
    #t.description(index_as: [:searchable, :displayable ])
    t.fileidentifier(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>'fileidentifier', :label=>'Fileidentifier')
    #t.fileidentifier(index_as: [:searchable, :displayable, :sortable])
    t.geo_lat
    t.geo_lng
    t.imagetype(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>{:attribute=>'imagetype'}, :label=>'Imagetype')
    #t.imagetype(:type => :string, :index_as=>[:facetable, :stored_searchable, :displayable, :sortable, ],:path=>'imagetype', :label=>'imagetype')
    t.local(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable,  :facetable],:path=>'local', :label=>'Lokal')
    t.path_to_image(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>'pathtoimage', :label=>'pathtoimage')
    t.opstilling(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>'opstilling', :label=>'opstilling')
  end

  def self.xml_template
    Nokogiri::XML.parse('<fields/>')
  end
end
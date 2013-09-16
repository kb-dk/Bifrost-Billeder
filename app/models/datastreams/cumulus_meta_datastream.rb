class CumulusMetaDatastream < ActiveFedora::OmDatastream

  set_terminology do |t|
    t.root(path: 'fields')
    t.title(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable],:path=>'title', :label=>'Title')
    t.author(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>'author', :label=>'Author')
    t.person(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>'person', :label=>'Person')
    t.category(:type => :text, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>'category', :label=>'Category')
    t.genre(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>'genre', :label=>'Genre')
    t.copyright(:type => :string, :index_as => [:stored_searchable, :displayable, :sortable, :facetable], :path => 'copyright', :label => 'Copyright')
    t.date_start(:type => :string, :index_as=>[:stored_searchable, :displayable, :facetable],:path=>'date_start', :label=>'date_start')
    t.date_end
    t.date_txt(:type => :string, :index_as=>[:stored_searchable, :displayable, :facetable],:path=>'date_txt', :label=>'date_txt')
    t.description(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>'description', :label=>'Description')
    t.lcsh(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>'lcsh', :label=>'lcsh')
    t.fileidentifier(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>'fileidentifier', :label=>'Fileidentifier')
    t.geo_lat
    t.geo_lng
    t.keywords(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>{:attribute=>'keywords'}, :label=>'keywords')
    t.imagetype(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>{:attribute=>'imagetype'}, :label=>'Imagetype')
    t.dimensions(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable, :facetable],:path=>{:attribute=>'dimensions'}, :label=>'dimensions')
    t.local(:type => :string, :index_as=>[:stored_searchable, :displayable, :sortable,  :facetable],:path=>'local', :label=>'Lokal')
    t.path_to_image(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>'pathtoimage', :label=>'pathtoimage')
    t.opstilling(:type => :string, :index_as=>[:stored_searchable, :displayable],:path=>'opstilling', :label=>'opstilling')
    t.cumulusuuid(:type=>:string, :index_as=> :stored_searchable)
  end

  def self.xml_template
    Nokogiri::XML.parse('<fields/>')
  end
end
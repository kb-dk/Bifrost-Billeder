# -*- encoding : utf-8 -*-
class Image < BifrostObject
  include Hydra::ModelMixins::RightsMetadata
  #include Solr::Indexable

  has_metadata 'rightsMetadata', type:  Hydra::Datastream::RightsMetadata

  has_metadata 'descMetadata', type: CumulusMetaDatastream

  attr_accessor  :record_id, :title, :author, :person, :category,:genre, :date_end, :date_start, :date_txt, :description,:lcsh, :fileidentifier, :geo_lat, :geo_lng, :imagetype, :local, :path_to_image, :opstilling, :copyright, :license_title, :license_description, :license_url

  delegate_to 'descMetadata', [:title, :author, :person, :category, :genre, :date_end, :date_start, :date_txt, :description, :lcsh, :fileidentifier, :geo_lat, :geo_lng, :keywords, :imagetype, :local, :path_to_image, :opstilling, :copyright], :unique => true

  delegate :license_title, :to=>'rightsMetadata', :at=>[:license, :title], :index_as=>[:stored_searchable, :displayable, :sortable], :unique=>true
  delegate :license_description, :to=>'rightsMetadata', :at=>[:license, :description], :unique=>true
  delegate :license_url, :to=>'rightsMetadata', :at=>[:license, :url], :unique=>true

  after_save :ensure_rights

  private
  def ensure_rights
    if permissions.empty?
      set_rights_from_copyrights(self)
    end
  end

  def set_rights_from_copyrights(image)
    case image.copyright
      when 'Det Kongelige Bibliotek'
        image.permissions = [{:name=>'public', :access=>'read', :type=>'group'},
                             {:name=>'registered', :access=>'edit', :type=>'group'}]
        image.license_title = image.copyright
        image.license_url = 'http://www.kb.dk'
        image.license_description = '??'
      when 'AAAAA'
        image.permissions = [{:name=>'public', :access=>'edit', :type=>'group'},
                             {:name=>'registered', :access=>'edit', :type=>'group'}]
        image.license_title = 'Creative Commons'
        image.license_url = 'http://creativecommons.org'
        image.license_description = '<a rel="license" href="http://creativecommons.org/licenses/by-nc-nd/3.0/deed.da"><img alt="Creative Commons licens" src="http://i.creativecommons.org/l/by-nc-nd/3.0/80x15.png"/></a>'
      when 'CCCCCCCCC'
        image.permissions = [{:name=>'public', :access=>'discover', :type=>'group'},
                             {:name=>'registered', :access=>'edit', :type=>'group'}]
        image.license_title = image.copyright
        image.license_url = 'http://www.kb.dk'
        image.license_description = 'CCCCCCCCC'
      when 'Billedet er muligvis beskyttet af loven om ophavsret'
        image.permissions = [{:name=>'public', :access=>'discover', :type=>'group'},
                             {:name=>'registered', :access=>'edit', :type=>'group'}]
        image.license_title = image.copyright
        image.license_url = 'http://www.kb.dk'
        image.license_description = '??'
      else
        image.permissions = [{:name=>'registered', :access=>'edit', :type=>'group'}]
        image.license_title = image.copyright
        image.license_url = 'http://www.kb.dk'
        image.license_description = '??'
    end
    #logger.debug 'Permissions set to: ' + image.permissions.to_s
    #logger.debug "License; title = #{image.license_title}, url = #{image.license_url}, description = #{image.license_description}"
    image.save!
  end
end
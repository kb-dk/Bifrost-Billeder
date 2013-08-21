# -*- encoding : utf-8 -*-
class Image < BifrostObject
  include Hydra::ModelMixins::RightsMetadata

  has_metadata 'rightsMetadata', type:  Hydra::Datastream::RightsMetadata

  has_metadata 'descMetadata', type: CumulusMetaDatastream

  attr_accessor  :record_id, :title, :author, :person, :category,:genre, :date_end, :date_start, :date_txt, :description,:lcsh, :fileidentifier, :geo_lat, :geo_lng, :imagetype, :local, :path_to_image, :opstilling, :copyright

  delegate_to 'descMetadata', [:title, :author, :person, :category, :genre, :date_end, :date_start, :date_txt, :description, :lcsh, :fileidentifier, :geo_lat, :geo_lng, :imagetype, :local, :path_to_image, :opstilling, :copyright], :unique => true

  after_save :ensure_rights

  private
  def ensure_rights
    if permissions.empty?
      set_rights_from_copyrights(self)
      save!
    end
  end

  def set_rights_from_copyrights(image)
    case image.copyright
      when 'Det Kongelige Bibliotek'
        image.permissions = [{:name=>'public', :access=>'read', :type=>'group'},
                             {:name=>'registered', :access=>'edit', :type=>'group'}]
        logger.debug 'Permissions for material copyrighted by The Royal Library' + image.permissions.to_s
      when 'AAAAA'
        image.permissions = [{:name=>'public', :access=>'edit', :type=>'group'},
                             {:name=>'registered', :access=>'edit', :type=>'group'}]
        logger.info 'Odd permissions, setting edit for all: ' + image.permissions.to_s
      when ''
        image.permissions = [{:name=>'public', :access=>'discover', :type=>'group'},
                             {:name=>'registered', :access=>'edit', :type=>'group'}]
        logger.info 'Inspecified permissions, setting default: ' + image.permissions.to_s
      else
        image.permissions = [{:name=>'registered', :access=>'edit', :type=>'group'}]
        logger.debug 'Setting default permissions ' + image.permissions.to_s
    end
  end
end
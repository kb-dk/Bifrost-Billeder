#class Image   < ActiveFedora::Base
class Image   < BifrostObject

 # has_metadata :name=>'rightsMetadata', :type=> Hydra::Datastream::RightsMetadata
 # has_metadata :name=>'descMetadata', :type=>  Hydra::Datastream::ModsArticle


  has_metadata 'rightsMetadata', type:  Hydra::Datastream::RightsMetadata
  #has_metadata 'descMetadata', type: Hydra::Datastream::ModsArticle
  #has_metadata 'descMetadata', type: ImageModsDatastream
  has_metadata 'descMetadata', type: CumulusMetaDatastream

  attr_accessor  :record_id, :title, :author, :person, :category,:genre, :date_end, :date_start, :date_txt, :description,:lcsh, :fileidentifier, :geo_lat, :geo_lng, :imagetype, :local, :path_to_image, :opstilling
=begin
  Accessionsnr
  Time
  År
  Emneord
  Keywords
  Person
=end

  delegate_to 'descMetadata', [:title, :author, :person, :category, :genre, :date_end, :date_start, :date_txt, :description, :lcsh, :fileidentifier, :geo_lat, :geo_lng, :imagetype, :local, :path_to_image, :opstilling], :unique => true

  #delegate :title, to: 'descMetadata'
  #delegate :imagetype,  to: 'descMetadata'
  #delegate :author,  to: 'descMetadata'
  #delegate :category,  to: 'descMetadata'
  #delegate :description,  to: 'descMetadata'
  #delegate :title, to: 'descMetadata'

  #delegate :author, to: 'descMetadata'
  #delegate :local, to: 'descMetadata'


=begin
  def to_solr(solr_doc={})
    super
    solr_doc["title_tsim"] = self.title
    solr_doc["author_tsim"] = self.author
    solr_doc["local_tsim"] = self.local
    solr_doc["imagetype_tsim"] = self.imagetype

    solr_doc["description_tsim"] = self.description
    solr_doc["fileidentifier_tsim"] = self.fileidentifier

    return solr_doc
  end

=end

=begin
    if !(self.title.nil? or self.title.empty?)
     solr_doc["title_t"] = self.title

    end



    if !(self.description.nil? or self.description.empty?)
      solr_doc["description_t"] = self.description
    end


    if !(self.fileidentifier.nil? or self.fileidentifier.empty?)
      solr_doc["fileidentifier_t"] = self.fileidentifier
    end


    if !(self.author.nil? or self.author.empty?)
      solr_doc["author_t"] = self.author
      solr_doc["author_display"] = self.author
    end

    if !(self.category.nil? or self.category.empty?)
      solr_doc["category_t"] = self.category
      solr_doc["category_display"] = self.category
    end

    if !(self.date_start.nil? or self.date_start.empty?)
      solr_doc["date_start_t"] = self.date_start
    end


    if !(self.imagetype.nil? or self.imagetype.empty?)
      solr_doc["imagetype_t"] = self.imagetype
      solr_doc["imagetype_display"] = self.imagetype
    end

    if !(self.local.nil? or self.local.empty?)
      solr_doc["local_t"] = self.local
    end
=end

  end

=begin

Imagetype:
Local:
Fileid:
Category:
test
Geo lat:
Geo lng:
Date start:
Date end:
Description:
test test test test
Path to image:



  def to_solr(solr_doc={})
    super
    solr_doc["title_t"] = self.title
    solr_doc["licens_title_t"] = self.license_title
    solr_doc["licens_description_t"] = self.license_description
    solr_doc["forfatter_t"]  = self.get_authors.map{ |a| a["sn"] + ", " +a["gn"] }.join("; ")
    solr_doc["forfatter_sort"] = solr_doc["forfatter_t"]
    return solr_doc
  end
=end
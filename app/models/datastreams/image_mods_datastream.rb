

class ImageModsDatastream < ActiveFedora::NokogiriDatastream

  MODS_NS = 'http://www.loc.gov/mods/v3'
  MODS_SCHEMA = 'http://www.loc.gov/standards/mods/v3/mods-3-3.xsd'
  MODS_PARAMS = {
      "version"            => "3.3",
      "xmlns:xlink"        => "http://www.w3.org/1999/xlink",
      "xmlns:xsi"          => "http://www.w3.org/2001/XMLSchema-instance",
      "xmlns"              => MODS_NS,
      "xsi:schemaLocation" => "#{MODS_NS} #{MODS_SCHEMA}",
  }

  # OM (Opinionated Metadata) terminology mapping for the mods xml
  set_terminology do |t|
    t.root(:path => "mods", :xmlns => MODS_NS, :schema => MODS_SCHEMA)


    t.titleInfo do
      t.title(:index_as => [:searchable, :displayable, :sortable])
      t.subTitle(:index_as => [:searchable, :displayable, :sortable])
    end


    # <name type="personal">
    # <namePart>Fornavn Efternavn</namePart>                 <!-- Forfatter author for og efternavn -->
    #    <role>
    #        <roleTerm authority="marcrelator" type="text">Creator</roleTerm> <!-- author role -->
    #                                                                                                                           </role>
    #</name>

    t.name do
      t.namePart(:index_as => [:searchable, :displayable, :sortable])
      t.role do
        t.roleTerm
      end
    end

    t.abstract(:index_as => [:searchable, :displayable])

    #<originInfo>
    #<dataIssued>2011</dateIssued>                             <!-- Afleveringsår -->
    #      <location>
    #           <physicalLocation>Biologi</physicalLocation>              <!--  fysisk sted -->
    #</location>
    # </originInfo>

    t.originInfo do
      t.dataIssued(:index_as => [:searchable, :facetable, :displayable, :sortable])    # :facetable
      t.location do
        t.physicalLocation(:index_as => [:searchable, :displayable, :facetable])
      end
    end


    t.typeOfResource(:index_as=>[:searchable])
    t.identifier(:index_as=>[:searchable])
    t.fileidcumulus(:index_as=>[:searchable])

    t.genre(:index_as=>[:searchable, :displayable, :facetable])



    # these proxy declarations allow you to use more familiar term/field names that hide the details of the XML structure
    t.title(:proxy => [:titleInfo, :title])
   # t.undertitel(:proxy => [:titleInfo, :subTitle])
    t.author(:proxy => [:name, :namePart])
    t.description(:proxy => [:abstract])
    t.date_start(:proxy => [:originInfo, :dataIssued])

    t.local(:proxy => [:originInfo, :location, :physicalLocation])

    t.category(:proxy => [:genre])

    t.fileidentifier(:proxy => [:fileidcumulus])

    t.path_to_image(:proxy => [:identifier])
  end # set_terminology



  def self.xml_template
    Nokogiri::XML::Builder.new do |xml|
      xml.mods(MODS_PARAMS) {
        xml.titleInfo {
          xml.title
          xml.subtitle
        }
        xml.name {
          xml.namePart
          xml.role {
            xml.roleTerm("author", :authority => "marcrelator", :type => "text")
          }
        }
        xml.abstract
        xml.originInfo {
          xml.dateIssued
          xml.location {
            xml.physicalLocation
          }
        }
        xml.genre
        xml.identifier
        xml.fileidcumulus
        xml.language {
          xml.languageTerm
        }
        xml.identifier(:displayLabel =>"image", :type => "uri")

        #<md:identifier displayLabel="image" type="uri" xmlns:java="http://xml.apache.org/xalan/java" xmlns:mix="http://www.loc.gov/mix/v10">http://www.kb.dk/imageService/online_master_arkiv_12/non-archival/Maps/FYNLUFTFOTO/B-serien/B02433/B02433_008j.jpg</md:identifier>
        #<md:identifier displayLabel="thumbnail" type="uri" xmlns:java="http://xml.apache.org/xalan/java" xmlns:mix="http://www.loc.gov/mix/v10">http://www.kb.dk/imageService/w150/h150/online_master_arkiv_12/non-archival/Maps/FYNLUFTFOTO/B-serien/B02433/B02433_008j.jpg</md:identifier>
      }

    end.doc
  end




end # class

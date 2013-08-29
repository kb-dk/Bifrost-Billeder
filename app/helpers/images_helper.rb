# encoding: utf-8
module ImagesHelper

  def create_image(filename)
    doc = REXML::Document.new File.new(filename)
    #logger.debug  doc.root.size
    @image = Image.new()
    list_of_persons = Array.new
    list_of_keywords = Array.new

    doc.root.elements.each('field/value') do |element|
      if element.parent.attributes['name'] == 'record_id'
        @image.record_id = element.text
      end
      if element.parent.attributes['name'] == 'Titel'
        @image.title = element.text
      end
      if element.parent.attributes['name'] == 'Ophav'
        @image.author = element.text
      end
      if element.parent.attributes['name'] == 'Opstilling'
        @image.opstilling = element.text
      end
      if element.parent.attributes['name'] == 'Genre'
        @image.genre  = element.text
      end
      if element.parent.attributes['name'] == 'Lokalitet'
        @image.local = element.text.split(',')
      end
      if element.parent.attributes['name'] == 'Categories'
        @image.category = element.text.split(',')
      end
      if element.parent.attributes['name'] == 'Record Name'
        @image.fileidentifier = element.text
      end
      if element.parent.attributes['name'] == 'Materialebetegnelse'
        @image.imagetype = element.text
      end
      if element.parent.attributes['name'] == 'Generel materialebetegnelse'
        if @image.imagetype.nil? || @image.imagetype.empty?
          @image.imagetype = element.text
        else
          @image.imagetype << element.text
        end
      end
      if element.parent.attributes['name'] == 'Time'
        @image.date_txt = element.text
      end

      if element.parent.attributes['name'] == 'År'
        @image.date_start = element.text
      end

      if element.parent.attributes['name'] == 'Asset Reference'
        @image.path_to_image = element.text
        # http://www.kb.dk/imageService/w450/online_master_arkiv_11/non-archival/Images/BILLED/2011/apr/DH_kvart/DH008765.jpg
        #http://www.kb.dk/imageService/w450/online_master_arkiv_6/non-archival/Images/BILLED/2008/Billede/kendis/ke001513.jpg
      end
      if element.parent.attributes['name'] == 'Note'
        if @image.description.nil? || @image.description.empty?
          @image.description = element.text
        else
          @image.description = @image.description + '.' + element.text
        end
      end
      #if element.parent.attributes['name'] == 'Person'
      #  if @image.description.nil? || @image.description.empty?
      #    @image.description = element.text
      #  else
      #    @image.description = @image.description + 'Person: ' + element.text
      #  end
      #end
      if element.parent.attributes['name'] == 'Emneord'
        list_of_keywords.push(element.text)
      end



      if element.parent.attributes['name'] == 'Person'
        logger.debug("PERSON #{element.text}" )
        if @image.person.nil? || @image.person.empty? || @image.person.length < 1
          #@image.person = Array.new
          #arra = ["12", "34"]

          #arra.push(element.text)
         # @image.person.push(element.text)
          @image.person = element.text
          list_of_persons.push(element.text)


        else

          #arra.push(element.text)
          @image.person = (@image.person + ";" + element.text)
          list_of_persons.push(element.text)
          # @image.person.push( element.text)

        end
      end
      if element.parent.attributes['name'] == 'Copyright'
        @image.copyright = element.text
      end
    end

    #splitting on , for each person
    #if !@image.person.nil? && !@image.person.empty? && @image.person.length > 0
    #  @image.person = @image.person.split(';')
    #end
    @image.person = list_of_persons
    logger.debug ("         list_of_persons: #{list_of_persons}")
    @image.keywords = list_of_keywords
    logger.debug ("         list_of_keywords: #{list_of_keywords}")
    @image
  end
end

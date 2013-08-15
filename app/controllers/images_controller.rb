require 'rexml/document'


class ImagesController < ApplicationController
  # GET /images
  # GET /images.json
  def index
    #@images = Image.all
    logger.info( Image.count)
    redirect_to  root_url
    #@images = Image.find_in_batches(batch_size: 200)
#    @images = Image.find_in_batches(!'title' == '',{:batch_size => 10}) do |batch|
      #puts batch.to_s

      #@images  << batch
      #puts @images.size
 #   end
 #   puts @images.size

    #@images = Image.find_in_batches('title' != nil, {:batch_size=>50})
    #@images = Image.all
    #@images = Image.order("title").page(params[:page]).per(50)

  #  respond_to do |format|
   #   format.html # index.html.erb
    #  format.json { render json: @images }
   # end

  end

  # GET /images/1
  # GET /images/1.json
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      logger.info "FORMAT: #{format.to_s}"

      format.html # show.html.erb
      format.json { render json: @image }
      format.xml {
        logger.info "Returning XML!"
        render xml: @image }

    end
  end

  # GET /images/new
  # GET /images/new.json
  def new
    @image = Image.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end

  # GET /images/1/edit
  def edit
    @image = Image.find(params[:id])
  end

  # POST /images
  # POST /images.json
  def create
    @image = Image.new(params[:image])

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Image was successfully created.' }
        format.json { render json: @image, status: :created, location: @image }
      else
        format.html { render action: "new" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /images/1
  # PUT /images/1.json
  def update
    @image = Image.find(params[:id])

    respond_to do |format|
      if @image.update_attributes(params[:image])
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    @image = Image.find(params[:id])
    @image.destroy

    respond_to do |format|
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end


=begin
  def loadallimagesfromfilesystem
    logger.info("LOAD ALL IMAGES FROM FILE SYSTEM")
    Dir.foreach('/Users/abw/Downloads/Samlingsbilleder_2136') do |item|
      next if item == '.' or item == '..'
      # do work on real items
      logger.info(item)
    end
  end
=end



  def reloadsolrindex
    stat_counter = 0
    @images = Image.all
    @images.each do |image|
      logger.debug("updating index for image: " + image.title.to_s )
      stat_counter += 1
      image.update_index
    end
    logger.info("done reloading solr index")
    redirect_to  root_url, notice: "#{stat_counter} images was successfully reindexed to solr."
  end


  def emptysystem
    stat_counter = 0
    @images = Image.all
    @images.each do |image|
      logger.debug("deleting image: " + image.title.to_s )
      stat_counter += 1
       image.destroy
    end
    logger.info("emptied the database")
    redirect_to  root_url, notice: "#{stat_counter} images was successfully deleted."
  end

  def loadallxmlfromglobal
    stat_counter = 0
    stat_beginning = Time.now
    logger.info("LOAD ALL XML FILES FROM SYSTEM")

    #Dir.glob('/Users/abw/Downloads/Samlingsbilleder_2136/master_records_2500/*.xml') do |filename|
#    Dir.glob('/Users/abw/Downloads/Samlingsbilleder_2136/master_records_subset/*.xml') do |filename|
    Dir.glob('test/fixtures/master_records_test_subset/*.xml') do |filename|
    #Dir.glob('/Users/abw/Downloads/Samlingsbilleder_2136/master_records/*.xml') do |filename|
    # 700 MB XML metadata
    #Dir.glob('/Users/abw/Downloads/Samlingsbilleder_2108/master_records/*.xml') do |filename|
      #logger.info(filename)

      doc = REXML::Document.new File.new(filename)
      #logger.debug  doc.root.size
      @image = Image.new()
      doc.root.elements.each("field/value") do |element|
        #logger.debug element.parent.attributes
        if element.parent.attributes["name"] == "record_id"
          #logger.debug element.parent.attributes
          #logger.debug element.text
          @image.record_id = element.text
        end

        if element.parent.attributes["name"] == "Titel"
          #logger.debug element.parent.attributes
          #logger.debug element.text
          @image.title = element.text
        end
        if element.parent.attributes["name"] == "Ophav"
          #logger.debug element.parent.attributes
          #logger.debug element.text
          @image.author = element.text
        end


        if element.parent.attributes["name"] == "Opstilling"
          #logger.debug element.parent.attributes
          #logger.debug element.text
          @image.opstilling = element.text
        end
        if element.parent.attributes["name"] == "Genre"
          #logger.debug element.parent.attributes
          #logger.debug element.text
          @image.genre  = element.text
        end


        if element.parent.attributes["name"] == "Lokalitet"
          #logger.debug element.parent.attributes
          #logger.debug element.text
          @image.local = element.text.split(',')

        end

        if element.parent.attributes["name"] == "Categories"
          #logger.debug element.parent.attributes
          #logger.debug element.text
          @image.category = element.text.split(',')
        end

        if element.parent.attributes["name"] == "Record Name"
          #logger.debug element.parent.attributes
          #logger.debug element.text
          @image.fileidentifier = element.text
          #<value>ke000063.tif</value>
         end

=begin
        if element.parent.attributes["name"] == "objectIdentifierValue"
          #  <value>Uid:dk:kb:doms:2007-01/cae69b60-1ca0-11df-bcd1-0016357f605f</value>
          logger.debug element.parent.attributes
          logger.debug element.text
        end
=end

        if element.parent.attributes["name"] == "Materialebetegnelse"
          #   <value>Fotografi</value>
          #logger.debug element.parent.attributes
          #logger.debug element.text
          @image.imagetype = element.text

        end

        if element.parent.attributes["name"] == "Generel materialebetegnelse"
          #logger.info element.parent.attributes
          #logger.info element.text
          if @image.imagetype.nil? || @image.imagetype.empty?
            @image.imagetype = element.text
          else
            @image.imagetype << element.text
          end
        end

=begin
        if element.parent.attributes["name"] == "CHECKSUM_ORIGINAL_MASTER"
          logger.info element.parent.attributes
          logger.info element.text
        end
=end

        if element.parent.attributes["name"] == "Time"
          #logger.debug element.parent.attributes
          #logger.debug element.text
          @image.date_start = element.text

        end


         if element.parent.attributes["name"] == "Asset Reference"
           #logger.debug element.parent.attributes
           #logger.debug element.text
           @image.path_to_image = element.text

           # http://www.kb.dk/imageService/w450/online_master_arkiv_11/non-archival/Images/BILLED/2011/apr/DH_kvart/DH008765.jpg
           #http://www.kb.dk/imageService/w450/online_master_arkiv_6/non-archival/Images/BILLED/2008/Billede/kendis/ke001513.jpg

         end

        if element.parent.attributes["name"] == "Note"
          #logger.info element.parent.attributes
          #logger.info element.text
          if @image.description.nil? || @image.description.empty?
            @image.description = element.text
          else
            @image.description = @image.description + '.
            ' + element.text

          end

        end


        if element.parent.attributes["name"] == "Person"
          #logger.info element.parent.attributes
          #logger.info element.text
          if @image.description.nil? || @image.description.empty?
            @image.description = element.text
          else
            @image.description = @image.description + '
            Person: ' + element.text
          end

        end


      if element.parent.attributes["name"] == "Person"
        #logger.info element.parent.attributes
        #logger.info element.text
        if @image.person.nil? || @image.person.empty?
          @image.person = [element.text]
        else
          @image.person.push element.text
        end

      end
    end

      # all done parsing xml. Try save the image
      if @image.save
        #logger.info("Saved image")
        stat_counter += 1
      else
        logger.error("error saving image")
      end


    end
    logger.info "#{stat_counter} images. Time elapsed #{Time.now - stat_beginning} seconds"
    logger.info "#{stat_counter} images. Time elapsed #{(Time.now - stat_beginning)/60} minutes"
    stat_timelapsed = "#{(Time.now - stat_beginning)/60} minutes"
    redirect_to  root_url, notice: "#{stat_counter} images was successfully loaded in #{stat_timelapsed}"

  end
end

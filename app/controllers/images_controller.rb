require 'rexml/document'


class ImagesController < ApplicationController
  # GET /images
  # GET /images.json
  def index
    #@images = Image.all
    logger.info( Image.count)


    #@images = Image.find_in_batches(batch_size: 200)
    #@images = Image.find_in_batches('title_t' != '', {:batch_size=>50})
    #@images = Image.find_in_batches('title' != nil, {:batch_size=>50})
    @images = Image.all
    #@images = Image.order("title").page(params[:page]).per(50)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images }
    end
  end

  # GET /images/1
  # GET /images/1.json
  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
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

  # GET /images
  # GET /images.json
  def emptysystem
    @images = Image.all
    @images.each do |image|
      logger.info("deleting image: " + image.title.to_s )
       image.destroy
    end
    logger.info("emptied the database")
    redirect_to  action: 'index', notice: 'Images was successfully deleted.'
  end


  def loadallxmlfromglobal
    logger.info("LOAD ALL XML FILES FROM SYSTEM")

    Dir.glob('/Users/abw/Downloads/Samlingsbilleder_2136/master_records_subset/*.xml') do |filename|
    #Dir.glob('/Users/abw/Downloads/Samlingsbilleder_2136/master_records/*.xml') do |filename|
      logger.info(filename)

      doc = REXML::Document.new File.new(filename)
      logger.info  doc.root.size
      @image = Image.new()
      doc.root.elements.each("field/value") do |element|
        #logger.debug element.parent.attributes
        if element.parent.attributes["name"] == "record_id"
          logger.info element.parent.attributes
          logger.info element.text
          @image.record_id = element.text
        end

        if element.parent.attributes["name"] == "Titel"
          logger.info element.parent.attributes
          logger.info element.text
          @image.title = element.text

        end
        if element.parent.attributes["name"] == "Opstilling"
          logger.info element.parent.attributes
          logger.info element.text

        end

        if element.parent.attributes["name"] == "Lokalitet"
          logger.info element.parent.attributes
          logger.info element.text
          @image.local = element.text

        end

        if element.parent.attributes["name"] == "Record Name"
          logger.info element.parent.attributes
          logger.info element.text
          @image.fileidentifier = element.text
          #<value>ke000063.tif</value>

        end


        if element.parent.attributes["name"] == "objectIdentifierValue"
          #  <value>Uid:dk:kb:doms:2007-01/cae69b60-1ca0-11df-bcd1-0016357f605f</value>
          logger.info element.parent.attributes
          logger.info element.text
        end


        if element.parent.attributes["name"] == "Materialebetegnelse"
          #   <value>Fotografi</value>
          logger.info element.parent.attributes
          logger.info element.text
          @image.imagetype = element.text

        end


        if element.parent.attributes["name"] == "CHECKSUM_ORIGINAL_MASTER"
          logger.info element.parent.attributes
          logger.info element.text
        end






        if element.parent.attributes["name"] == "Time"
          logger.info element.parent.attributes
          logger.info element.text
          @image.date_start = element.text

        end


         if element.parent.attributes["name"] == "Asset Reference"
           logger.info element.parent.attributes
           logger.info element.text
           @image.path_to_image = element.text

           # http://www.kb.dk/imageService/w450/online_master_arkiv_11/non-archival/Images/BILLED/2011/apr/DH_kvart/DH008765.jpg
           #http://www.kb.dk/imageService/w450/online_master_arkiv_6/non-archival/Images/BILLED/2008/Billede/kendis/ke001513.jpg

         end

        if element.parent.attributes["name"] == "Note"
          logger.info element.parent.attributes
          logger.info element.text
          if @image.description.nil?
            @image.description = element.text
          else
            @image.description << element.text
          end

        end




        #logger.debug element.text

      end

      # all done parsing xml. Try save the image
      if @image.save
        logger.info("Saved image")
      else
        logger.error("error saving image")
      end


    end
    redirect_to  action: 'index', notice: 'Images was successfully loaded.'

  end
end

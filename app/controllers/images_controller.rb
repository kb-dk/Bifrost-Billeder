require 'rexml/document'


class ImagesController < ApplicationController
  include ImagesHelper

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
    authorize! :read, params[:id]
    puts "params: #{params.inspect.to_s}"
    puts "user: #{current_user.inspect.to_s}"
    #puts ""

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
    authorize! :edit, params[:id]


    @image = Image.find(params[:id])
  end

  # GET /images/1/edit_rights
  def edit_rights
    authorize! :edit, params[:id]

    @image = Image.find(params[:id])
    puts "Image: #{@image.inspect.to_s}"
    @image
  end

  # POST /images
  # POST /images.json
  def create
    authorize! :edit, params[:id]

    @image = Image.new(params[:image])
    @image.created_at = DateTime.now
    @image.editor = ">>>READ FROM SESSION<<<"
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
    authorize! :edit, params[:id]

    @image = Image.find(params[:id])

    respond_to do |format|

      @image.update_at = DateTime.now
      @image.editor = ">>>READ FROM SESSION<<<"

      if @image.update_attributes(params[:image])
        format.html { redirect_to @image, notice: 'Image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /images/1
  # PUT /images 1.json
  def update_rights
    authorize! :edit, params[:id]

    @image = Image.find(params[:id])

    respond_to do |format|
      if set_rigths(params[:rights], @image)
        format.html { redirect_to @image, notice: 'Rights was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit_rights" }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /images/1
  # DELETE /images/1.json
  def destroy
    authorize! :edit, params[:id]
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
    localpath = params[:path]
    stat_counter = 0
    stat_beginning = Time.now
    if(localpath.blank?)
      localpath = 'test/fixtures/master_records_test_subset/*.xml'
      #localpath = 'test/fixtures/masters2/*.xml'
    end
    logger.info("LOAD ALL XML FILES FROM SYSTEM path #{localpath} ")


    Dir.glob(localpath) do |filename|

      @image = create_image filename
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

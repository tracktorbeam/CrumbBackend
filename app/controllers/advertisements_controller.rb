class AdvertisementsController < ApplicationController
  before_filter :initialize_semantic3_client
  before_filter :fetch_current_consumer

  # GET /advertisements
  # GET /advertisements.json
  def index
    @advertisements = Advertisement.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @advertisements }
    end
  end


  # GET /advertisements/1
  # GET /advertisements/1.json
  def show
    consumer_id = params[:id]
    consumer = Consumer.where(crumb_id: consumer_id).first
    if (consumer)
      advertisement = consumer.generate_advertisment
      if (advertisement)
        render json: advertisement
      else
        render status: 200, nothing: true
      end
    else
      render status: 401, nothing: true
    end
  end


  # GET /advertisements/new
  # GET /advertisements/new.json
  def new
    @advertisement = Advertisement.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @advertisement }
    end
  end

  # GET /advertisements/1/edit
  def edit
    @advertisement = Advertisement.find(params[:id])
  end

  # POST /advertisements
  # POST /advertisements.json
  def create
    @advertisement = Advertisement.new(params[:advertisement])

    respond_to do |format|
      if @advertisement.save
        format.html { redirect_to @advertisement, notice: 'Advertisement was successfully created.' }
        format.json { render json: @advertisement, status: :created, location: @advertisement }
      else
        format.html { render action: "new" }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /advertisements/1
  # PUT /advertisements/1.json
  def update
    @advertisement = Advertisement.find(params[:id])

    respond_to do |format|
      if @advertisement.update_attributes(params[:advertisement])
        format.html { redirect_to @advertisement, notice: 'Advertisement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @advertisement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advertisements/1
  # DELETE /advertisements/1.json
  def destroy
    @advertisement = Advertisement.find(params[:id])
    @advertisement.destroy

    respond_to do |format|
      format.html { redirect_to advertisements_url }
      format.json { head :no_content }
    end
  end

  protected
    def initialize_semantic3_client
      @sem3 = Semantics3::Products.new(SEMANTIC3_API_KEY,SEMANTIC3_API_SECRET)
    end

    def fetch_current_consumer
      @consumer = Consumer.first
    end

end

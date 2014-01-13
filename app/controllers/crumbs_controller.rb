class CrumbsController < ApplicationController
  before_filter :fetch_current_retailer, :except => [:post, :put]
  before_filter :fetch_current_store, :except => [:post, :put]  

  # GET /crumbs
  # GET /crumbs.json
  def index
    @consumer_activity = {}
    Consumer.all.each do |consumer|
      @consumer_activity[consumer.consumer_id] = consumer.activity(@store)
    end    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @consumers }
    end
  end

  # GET /crumbs/1
  # GET /crumbs/1.json
  def show
    @crumb = Crumb.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @crumb }
    end
  end

  # GET /crumbs/new
  # GET /crumbs/new.json
  def new
    @crumb = Crumb.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @crumb }
    end
  end

  # GET /crumbs/1/edit
  def edit
    @crumb = Crumb.find(params[:id])
  end

  # POST /crumbs
  # POST /crumbs.json
  def create
    beacon = Beacon.find(params[:uuid] + '_' + params[:major] + '_' + params[:minor])
    consumer = Consumer.new(consumer_id: params[:consumer])
    consumer.upsert

    crumb = Crumb.new
    crumb.beacon = beacon
    crumb.consumer = consumer

    respond_to do |format|
      if crumb.save
        format.html { redirect_to crumb, notice: 'Crumb was successfully created.' }
        format.json { render json: {"status" => "success"}, status: 200 }
      else
        format.html { render action: "new" }
        format.json { render json: {"status" => "error"}, status: :unprocessable_entity }
      end
    end
  end

  # PUT /crumbs/1
  # PUT /crumbs/1.json
  def update
    @crumb = Crumb.find(params[:id])

    respond_to do |format|
      if @crumb.update_attributes(params[:crumb])
        format.html { redirect_to @crumb, notice: 'Crumb was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @crumb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /crumbs/1
  # DELETE /crumbs/1.json
  def destroy
    @crumb = Crumb.find(params[:id])
    @crumb.destroy

    respond_to do |format|
      format.html { redirect_to crumbs_url }
      format.json { head :no_content }
    end
  end


  protected
    def fetch_current_retailer
      @retailer = Retailer.first
    end

    def fetch_current_store
      @store = Retailer.first.stores.first
    end

end

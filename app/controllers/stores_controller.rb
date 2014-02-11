class StoresController < ApplicationController
  before_filter :fetch_current_retailer, :except => [:post, :put]
  before_filter :fetch_current_store, :except => [:post, :put]


  # GET /dashboard
  def dashboard

    respond_to do |format|
      format.html # dashboard.html.erb
    end
  end


  # GET /stores/1
  # GET /stores/1.json
  def show
    @store = Store.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @store }
    end
  end
  

  # GET /stores/new
  # GET /stores/new.json
  def new
    @store = Store.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store }
    end
  end


  # GET /stores/1/edit
  def edit
    @store = Store.find(params[:id])
  end


  # POST /stores
  # POST /stores.json
  def create
    @store = Store.new(params[:store])

    respond_to do |format|
      if @store.save
        format.html { redirect_to @store, notice: 'Store was successfully created.' }
        format.json { render json: @store, status: :created, location: @store }
      else
        format.html { render action: "new" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end


  # PUT /stores/1
  # PUT /stores/1.json
  def update
    @store = Store.find(params[:id])

    respond_to do |format|
      if @store.update_attributes(params[:store])
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store = Store.find(params[:id])
    @store.destroy

    respond_to do |format|
      format.html { redirect_to stores_url }
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

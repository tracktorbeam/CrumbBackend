class PassesController < ApplicationController
  before_filter :fetch_current_retailer, :except => [:post, :put]
  before_filter :fetch_current_store, :except => [:post, :put]
  
  #GET /passes/qrcode/1
  def qrcode
    respond_to do |format|
      format.svg {render :qrcode => (url_for :controller => 'passes', :action => 'download', :id => params[:id])}
    end   
  end

  # GET /passes/download/1
  def download
    retailer = Retailer.find(params[:id])
    if (retailer)
      pass = retailer.passes.create
      pass.generate_compressed_pass
    
      compressed_pass_file_path = Rails.root.join('passes', retailer.id, retailer.name + '.pkpass').to_s 
      send_file compressed_pass_file_path, :type => 'application/vnd.apple.pkpass', :filename => retailer.name + '|' + Time.now.utc.to_s.gsub(/\s+/, "") + '.pkpass'
    else
      render nothing: true
    end
  end

  # POST passes/:version/devices/:device_library_identifier/registrations/:pass_type_identifier/:serial_number
  def register_device_for_pass
    version = params[:version]

    device_library_identifier = params[:device_library_identifier]
    push_token = params[:pushToken]

    pass_type_identifier = params[:pass_type_identifier]
    serial_number = params[:serial_number]
    authentication_token = request.headers['Authorization'].split[1]

    pass = Pass.where(passTypeIdentifier: pass_type_identifier, serialNumber: serial_number.to_i, authenticationToken: authentication_token).first
    if (pass)
      device = Device.where(device_library_identifier: device_library_identifier, push_token: push_token).first_or_create
      if (device)
        begin
          device.passes.find(pass.id)
          render status:200, nothing: true
        rescue
          device.passes << pass
          render status: 201, nothing: true
        end
      else
        render status:401, nothing: true
      end
    else
      render status:401, nothing:true
    end 
  end

  #GET passes/:version/devices/:device_library_identifier/registrations/:pass_type_identifier
  def fetch_pass_serial_numbers_for_device
    version = params[:version]

    device_library_identifier = params[:device_library_identifier]

    pass_type_identifier = params[:pass_type_identifier]
    passes_updated_since = params[:passesUpdatedSince]

    device = Device.where(device_library_identifier: device_library_identifier).first
    if (device)
      serial_numbers = device.passes.select { |pass| pass.passTypeIdentifier == pass_type_identifier }
      if (passes_updated_since)
        last_update = Time.parse(passes_updated_since)
        serial_numbers = serial_numbers.select {|pass| pass.updated_at > last_update}
      end
      
      if (serial_numbers.length > 0)
        response = { "lastUpdated" => Time.now.utc.to_s, "serialNumbers" => serial_numbers.map {|pass| pass.serialNumber} }
        render status:200, json: response
      else
        render status:204, nothing: true
      end
    else
      render status:401, nothing: true
    end
  end

  #GET passes/:version/passes/:pass_type_identifier/:serial_number
  def fetch_latest_pass
    version = params[:version]

    pass_type_identifier = params[:pass_type_identifier]
    serial_number = params[:serial_number]
    authentication_token = request.headers['Authorization'].split[1]

    pass = Pass.where(passTypeIdentifier: pass_type_identifier, serialNumber: serial_number.to_i, authenticationToken: authentication_token).first
    if (pass)
      pass.generate_compressed_pass
      compressed_pass_file_path = Rails.root.join('passes', pass.retailer.id, pass.retailer.name + '.pkpass').to_s
      send_file compressed_pass_file_path, :type => 'application/vnd.apple.pkpass' 
    else
      render status:401, nothing: true
    end
  end

  #DELETE passes/:version/devices/:device_library_identifier/registrations/:pass_type_identifier/:serial_number
  def unregister_device_for_pass
    version = params[:version]

    device_library_identifier = params[:device_library_identifier]

    pass_type_identifier = params[:pass_type_identifier]
    serial_number = params[:serial_number]
    authentication_token = request.headers['Authorization'].split[1]

    pass = Pass.where(passTypeIdentifier: pass_type_identifier, serialNumber: serial_number.to_i, authenticationToken: authentication_token).first
    device = Device.where(device_library_identifier: device_library_identifier).first
   
     if (pass)
      pass.delete
    end
    if (device)
      device.delete
    end
    
    render status: 200, nothing: true
  end

  #POST passes/:version/log
  def error_log
    errors = params[:logs]
  
    errors.map {|error| ap error }

    render status: 200, nothing: true
  end

  # POST passes/reconcile/:consumer_id
  def reconcile_pass_and_consumer
    consumer_id = params[:consumer_id]
    passes = params[:passes]

    if (consumer_id)
      consumer = Consumer.find_or_create_by(crumb_id: consumer_id)
      passes.each do |pass|
        pass_type_identifier = pass["passTypeIdentifier"]
        authentication_token = pass["authenticationToken"]
        serial_number = pass["serialNumber"]
        if (pass_type_identifier and authentication_token and serial_number)
          pass = Pass.where(passTypeIdentifier: pass_type_identifier, serialNumber: serial_number.to_i, authenticationToken: authentication_token).first
          consumer.passes << pass
        end
      end 
      render status:200, nothing: true
    else
      render status:401, nothing: true
    end
  end
  

  # GET /passes
  # GET /passes.json
  def index
    @passes = Pass.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @passes }
    end
  end

  # GET /passes/account/:retailer_id/:pass_type_identifier/:serial_number/:authentication_token
  def account
    retailer_id = params[:retailer_id]
    retailer = Retailer.find(retailer_id)
    if (retailer)
      pass_type_identifier = params[:pass_type_identifier]
      serial_number = params[:serial_number]
      authentication_token = params[:authentication_token]
      if (pass_type_identifier and serial_number and authentication_token)
        pass = retailer.passes.where(passTypeIdentifier: pass_type_identifier, serialNumber: serial_number, authenticationToken: authentication_token).first
        if (pass)
          @offers = pass.offers
          respond_to do |format|
            format.html # account.html.erb
          end
        else
          render status:401, nothing: true
        end
      else
        render status:401, nothing: true
      end
    else
      render status:401, nothing: true
    end
  end

  # GET /passes/new
  # GET /passes/new.json
  def new
    @pass = Pass.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pass }
    end
  end

  # GET /passes/1/edit
  def edit
    @pass = Pass.find(params[:id])
  end

  # POST /passes
  # POST /passes.json
  def create
    @pass = Pass.new(params[:pass])

    respond_to do |format|
      if @pass.save
        format.html { redirect_to @pass, notice: 'Pass was successfully created.' }
        format.json { render json: @pass, status: :created, location: @pass }
      else
        format.html { render action: "new" }
        format.json { render json: @pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /passes/1
  # PUT /passes/1.json
  def update
    @pass = Pass.find(params[:id])

    respond_to do |format|
      if @pass.update_attributes(params[:pass])
        format.html { redirect_to @pass, notice: 'Pass was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pass.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /passes/1
  # DELETE /passes/1.json
  def destroy
    @pass = Pass.find(params[:id])
    @pass.destroy

    respond_to do |format|
      format.html { redirect_to passes_url }
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

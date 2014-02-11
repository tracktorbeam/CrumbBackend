class ShopController < ApplicationController
  def index
    @retailer = Retailer.first
    @store = @retailer.stores.first
    respond_to do |format|
      format.html { render :layout => false }
    end    
  end

  def qr
    @retailer = Retailer.first
    @store = @retailer.stores.first
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
end

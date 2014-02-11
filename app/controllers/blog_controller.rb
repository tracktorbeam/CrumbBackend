class BlogController < ApplicationController

  def index
    @consumer = Consumer.first
    @ad = @consumer.generate_advertisment

    respond_to do |format|
      format.html { render :layout => false }
    end    
  end

end

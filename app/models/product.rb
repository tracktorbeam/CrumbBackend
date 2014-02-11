class Product
  include Mongoid::Document
  include Mongoid::Timestamps

  after_create :fetch_product_info_from_semantic3

  field :upc, type: String
  field :_id, type: String, default: ->{ upc }
  field :name, type: String
  field :original_price, type: Float
  field :discounted_price, type: Float
  field :image_url, type: String
  field :fetched, type: Boolean, default: false

  protected

  def fetch_product_info_from_semantic3
    SEMANTIC3_MANAGER.products_field( "upc", self.upc )
    begin
      product_info = SEMANTIC3_MANAGER.get_products()["results"].first
      self.update_attributes(name: product_info["name"], original_price: product_info["price"].to_f, discounted_price: (product_info["price"].to_f * 0.8).round(2), image_url: product_info["images"].first, fetched: true)
    rescue
    end
  end

end

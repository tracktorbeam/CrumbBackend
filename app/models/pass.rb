class Pass
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :retailer
  belongs_to :consumer
  has_and_belongs_to_many :devices
 
  after_create :initialize_retailer_specific_content
  after_create :initialize_pass_default_content

  field :formatVersion, type: Integer, default: 1
  field :passTypeIdentifier, type: String
  auto_increment :serialNumber
  field :teamIdentifier, type: String, default: TRACKTORBEAM_TEAM_IDENTIFIER
  field :webServiceURL, type: String, default: CRUMB_BACKEND_PASSES_URL
  field :authenticationToken, type: String, default: ->{ _id }
  embeds_one :barcode
  field :organizationName, type: String
  field :description, type: String
  field :logoText, type: String
  field :foregroundColor, type: String, default: "rgb(255, 255, 255)"
  field :backgroundColor, type: String, default: "rgb(255, 153, 51)"
  embeds_one :generic

  embeds_many :offers, class_name: "Generic"

  def serialNumber
    read_attribute(:serialNumber).to_s 
  end

  def update_pass_with_offer(offer)
    save_current_pass_snapshot 
    self.generic.primaryFields.first.update_attributes(value: offer.primary_value, label: offer.primary_label, changeMessage: offer.primary_change_message)
    self.generic.secondaryFields.first.update_attributes(value: offer.expiration_value.strftime("%Y-%m-%dT%H:%M:%S%:z"), label: offer.expiration_label, isRelative: offer.expiration_is_relative, timeStyle: offer.expiration_time_style)
    self.generic.headerFields.first.update_attributes(value: self.offers.count.to_s)
    self.touch
  end

  def generate_compressed_pass
    retailer_pass_root_dir = Rails.root.join('passes', self.retailer.id)
    pass_json_file = File.open(retailer_pass_root_dir.join(self.retailer.name + '.pass', 'pass.json').to_s, 'w')
    pass_json_file.write(self.as_json(except: [:_id, :retailer_id, :updated_at, :consumer_id, :versions, :version]).to_json)
    pass_json_file.close()

    Dubai::Passbook.certificate = retailer_pass_root_dir.join(self.retailer.name.downcase + '.p12').to_s
    Dubai::Passbook.password = self.retailer.name.downcase
    File.open(retailer_pass_root_dir.join(self.retailer.name + '.pkpass').to_s, 'w') do |pass_signed_file|
      pass_signed_file.write Dubai::Passbook::Pass.new(retailer_pass_root_dir.join(self.retailer.name + '.pass').to_s).pkpass.string
    end
  end

  protected
  def initialize_retailer_specific_content
     self.update_attributes(organizationName: self.retailer.name, logoText: self.retailer.name, description: "Personalized, Real-Time " + self.retailer.name + " Pass", passTypeIdentifier: CRUMB_PASS_TYPE_IDENTIFIER_PREFIX + self.retailer.name.downcase + CRUMB_PASS_TYPE_IDENTIFIER_SUFFIX)
  end

  def initialize_pass_default_content
    self.create_barcode
    self.create_generic
  end

  def save_current_pass_snapshot
    offer = self.offers.create
    offer.update_attributes(attributes_without_ids(self.generic.attributes.clone))
  end 

  def attributes_without_ids(attributes)
    attributes.each do |key, value|
        if key == "_id"
            attributes.delete(key) 
        elsif value.is_a?(Hash)
            attributes[key] = attributes_without_ids(value)
        elsif value.is_a?(Array)
          value.each_with_index do |val, index|
            value[index] = attributes_without_ids(val)
          end
        end        
    end
    attributes
  end

end


class Barcode
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :message, type: String, default: "1234567890"
  field :format, type: String, default: "PKBarcodeFormatPDF417"
  field :messageEncoding, type: String, default: "iso-8859-1"

  embedded_in :pass, class_name: "Pass"
end


class Generic
  include Mongoid::Document
  include Mongoid::Timestamps

  embeds_many :primaryFields, class_name: "PassField"
  embeds_many :secondaryFields, class_name: "PassField"
  embeds_many :auxiliaryFields, class_name: "PassField"
  embeds_many :backFields, class_name: "PassField"
  embeds_many :headerFields, class_name: "PassField"
  
  after_create :initialize_generic_default_content

  embedded_in :pass, class_name: "Pass"

  protected
  def initialize_generic_default_content
    self.primaryFields.create(key: 'incentive', value: 'Offers tailored for you', label: 'Personalized Discount Card')
    self.secondaryFields.create(key: 'expiration', label: 'This pass auto-updates in the store', value: 'based on your shopping tastes & habits')
    self.auxiliaryFields.create(key: 'notice', value: 'Flip this pass over to access them', label: 'All your offers so far:')
    self.backFields.create(key: 'account', attributedValue: '<a href=\''+ CRUMB_BACKEND_URL + '/passes/account/' + self.pass.retailer.id + '/' + self.pass.passTypeIdentifier + '/' + self.pass.serialNumber + '/' + self.pass.authenticationToken + '\'>My ' + self.pass.retailer.name + ' Offers</a>', label: 'View & redeem all your offers.', value: CRUMB_BACKEND_URL + '/passes/account/' + self.pass.retailer.id + '/' + self.pass.passTypeIdentifier + '/' + self.pass.serialNumber + '/' + self.pass.authenticationToken)
    self.headerFields.create(key: 'incentive-count', label: 'Offers', value: self.pass.offers.count.to_s, textAlignment: 'PKTextAlignmentRight')
  end

end


class PassField
  include Mongoid::Document
  include Mongoid::Timestamps

  field :key, type: String
  field :value, type: String
  field :label, type: String
  field :isRelative, type: Boolean
  field :timeStyle, type: String
  field :attributedValue, type: String
  field :textAlignment, type: String
  field :changeMessage, type: String

  def serializable_hash(options)
    super(options).select { |_, v| v }
  end

  embedded_in :generic
end

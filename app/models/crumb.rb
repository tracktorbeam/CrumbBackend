class Crumb
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :beacon
  belongs_to :consumer

  field :observed_at, type: Time
  field :accuracy, type: Float
  field :rssi, type: Integer
  field :proximity, type: Integer

  def observed_at=(observed_at_date_string)
    write_attribute(:observed_at, Time.parse(observed_at_date_string))
  end

  def accuracy=(accuracy_string)
    write_attribute(:accuracy, accuracy_string.to_f)
  end

  def rssi=(rssi_string)
    write_attribute(:rssi, rssi_string.to_i)
  end

  def proximity=(proximity_string)
    write_attribute(:proximity, proximity_string.to_i)
  end  

end

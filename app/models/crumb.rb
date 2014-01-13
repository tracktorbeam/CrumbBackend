class Crumb
  include Mongoid::Document
  validates :beacon, presence: true
  validates :consumer, presence: true

  belongs_to :beacon
  belongs_to :consumer

  field :created_at, type: Time, default: ->{ Time.now }

end

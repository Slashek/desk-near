class Availability < ActiveRecord::Base
  attr_accessible :date, :listing_id, :quantity

  belongs_to :listing
end

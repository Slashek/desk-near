class Rating < ActiveRecord::Base
  attr_accessible :average, :count

  belongs_to :listing
end

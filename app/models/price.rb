class Price < ActiveRecord::Base
  attr_accessible :amount, :currency_code, :label, :period
  
  before_save :set_free_if_not_amount, :hardcode_period
  belongs_to :listing

  def set_free_if_not_amount
    self.label = 'Free' if !self.amount || self.amount==0
  end

  def hardcode_period
    self.period = 'Day'
  end
end

require 'spec_helper'

describe Price do
  before do
    @price = FactoryGirl.build(:price)
  end

  it 'is free if amount is 0' do
     @price.label = 'something' 
     @price.amount = 0
     @price.save
     assert_equal('Free', @price.label)
  end

  it 'is free if amount is nil' do
     @price.label = 'something' 
     @price.amount = nil
     @price.save
     assert_equal('Free', @price.label)
  end

  it 'has hardcoded period' do
     @price.period = 'Month'
     @price.save
     assert_equal('Day', @price.period)
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :availability do
    date "2012-12-22"
    quantity 1
  end
  
  factory :first_december, :class => :availability do
    date "2012-12-01"
    quantity 2
  end

  factory :second_december, :class => :availability do
    date "2012-12-02"
    quantity 1
  end

  factory :third_december, :class => :availability do
    date "2012-12-03"
    quantity 2
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "MyString"
  end

  factory :organization_kfc, :class => :organization do
    name "KFC"
  end

  factory :organization_starbucks, :class => :organization do
    name "starbucks"
  end

  factory :organization_coffee_heaven, :class => :organization do
    name "coffee_heaven"
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :amenity do
    name "MyString"
  end

  factory :amenity_wifi, :class => :amenity do
    name "wifi"
  end

  factory :amenity_coffee, :class => :amenity do
    name "coffee"
  end

  factory :amenity_foosball, :class => :amenity do
    name "foosball"
  end
end

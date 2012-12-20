# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :listing do
    amenities {[FactoryGirl.create(:amenity)]}
    organizations {[FactoryGirl.create(:organization)]}
    name "My wonderful listing"
    description "This place is great..."
    address "100 Main St, Boise, ID, 83702, USA"
    lat 43.36
    lon -116.13
    price {FactoryGirl.create(:price)}
   # price {[FactoryGirl.create(:price)]}
    quantity 8
    rating {FactoryGirl.create(:rating)}
   # rating {[FactoryGirl.create(:rating)]}
    web_listing_url "https://desksnear.me/workplaces/42"
    api_listing_url "https://desksnear.me/api/v1/listings/42"
    api_rating_url "https://desksnear.me/api/v1/listings/42/rating"
    api_connections_url "https://desksnear.me/api/v1/listings/42/connections"
    api_patrons_url "https://desksnear.me/api/v1/listings/42/patrons"
    api_availability_url "https://desksnear.me/api/v1/listings/42/availability"
    api_reservation_url "https://desksnear.me/api/v1/listings/42/reservation"
  end

  factory :listing_maciek, :class => :listing do
    amenities {[FactoryGirl.create(:amenity_wifi), FactoryGirl.create(:amenity_coffee), FactoryGirl.create(:amenity_foosball)]}
    organizations {[FactoryGirl.create(:organization_kfc),FactoryGirl.create(:organization_coffee_heaven),FactoryGirl.create(:organization_starbucks)]}
    name "Maciek's office"
    description "My home"
    address "Ursynowska street"
    lat 5
    lon 0
    price {FactoryGirl.create(:price)}
    quantity 8
    rating {FactoryGirl.create(:rating)}
    web_listing_url "https://desksnear.me/workplaces/42"
    api_listing_url "https://desksnear.me/api/v1/listings/42"
    api_rating_url "https://desksnear.me/api/v1/listings/42/rating"
    api_connections_url "https://desksnear.me/api/v1/listings/42/connections"
    api_patrons_url "https://desksnear.me/api/v1/listings/42/patrons"
    api_availability_url "https://desksnear.me/api/v1/listings/42/availability"
    api_reservation_url "https://desksnear.me/api/v1/listings/42/reservation"
  end

  factory :listing_faraway, :class => :listing do
    amenities {[FactoryGirl.create(:amenity_coffee), FactoryGirl.create(:amenity_foosball)]}
    organizations {[FactoryGirl.create(:organization_coffee_heaven),FactoryGirl.create(:organization_starbucks)]}
    name "Far away office"
    description "Away"
    address "Unknown"
    lat 50
    lon -100
    price {FactoryGirl.create(:price)}
    quantity 8
    rating {FactoryGirl.create(:rating)}
    web_listing_url "https://desksnear.me/workplaces/42"
    api_listing_url "https://desksnear.me/api/v1/listings/42"
    api_rating_url "https://desksnear.me/api/v1/listings/42/rating"
    api_connections_url "https://desksnear.me/api/v1/listings/42/connections"
    api_patrons_url "https://desksnear.me/api/v1/listings/42/patrons"
    api_availability_url "https://desksnear.me/api/v1/listings/42/availability"
    api_reservation_url "https://desksnear.me/api/v1/listings/42/reservation"
  end
end

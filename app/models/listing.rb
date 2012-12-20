class Listing < ActiveRecord::Base
  attr_accessible :address, :api_availability_url, :api_connections_url, :api_listing_url, :api_patrons_url, :api_rating_url, :api_reservation_url, :description, :lat, :lon, :name, :quantity, :score, :strict_match, :web_listing_url, :updated_at

  attr_accessor :score, :strict_match
  has_one :price
  has_one :rating
  has_and_belongs_to_many :amenities
  has_and_belongs_to_many :organizations

  def self.find_all_based_on_search(params)
    score_calculator = ScoreCalculator.new(params)
    listings = Listing.all
    listings.each do |listing|
      score_calculator.set_current_listing(listing)
      listing.strict_match = score_calculator.is_strict_matched?
    end
    self.sort_listings_based_on_score(listings)
  end

  def self.sort_listings_based_on_score(listings)
    listings
  end

  def self.collection_to_json(listings)
    return {"listing" => listings.to_json({
      :exclude => [ :id, :updated_at, :created_at ],
      :include => { 
      :price => { :exclude => [:id, :updated_at, :created_at] } 
    }
    }) }
  end 


end

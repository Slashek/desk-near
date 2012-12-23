class Listing < ActiveRecord::Base
  attr_accessible :address, :api_availability_url, :api_connections_url, :api_listing_url, :api_patrons_url, :api_rating_url, :api_reservation_url, :description, :lat, :lon, :name, :quantity, :score, :strict_match, :web_listing_url, :updated_at

  attr_accessor :score, :strict_match
  has_one :price
  has_one :rating
  has_many :availabilities
  has_and_belongs_to_many :amenities
  has_and_belongs_to_many :organizations

  def self.find_all_based_on_search(params)
    score_calculator = ScoreCalculator.new(params)
    # 2012-12-23 MKK: Definitely there will be problems with performance/memory if there re too many listings
    # For simplicity I have just ignore them for now
    listings = Listing.joins(:price).all
    # fiest we claculate scores for boundingbox, amenities etc
    listings.each do |listing|
      score_calculator.set_current_listing(listing)
      score_calculator.calculate_score_for_listing
      listing.strict_match = score_calculator.is_strict_matched?
    end
    score_calculator.calculate_scores
    listings.each do |listing|
      listing.score = score_calculator.calculate_final_score_for_listing(listing)
    end
    self.sort_listings_based_on_score(listings)
  end

  def self.sort_listings_based_on_score(listings)
    listings = listings.sort do |a, b| 
      a.score <=> b.score
    end
    listings
  end

  def as_json(options={})
    super(:except => [:id, :updated_at, :listing_id, :created_at],
          :methods => [:score, :strict_match],
          :include => { 
      :price => { :except => [:id, :updated_at, :listing_id, :created_at] } ,
      :rating => { :except => [:id, :listing_id,  :updated_at, :created_at] }
    })
  end


end

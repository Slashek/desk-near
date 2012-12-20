class ScoreCalculator

  attr_accessor :listings, :bounding_box, :amenities, :organizations, :price

  def initialize(params)
    self.bounding_box = BoundingBox.new(params["boundingbox"])
    self.amenities = params["amenities"] ? params["amenities"] : []
    self.organizations = params["organizations"] ? params["organizations"] : []
    self.price = params["price"] ? params["price"] : {}
  end

  def calculate_distance_for_listing
    self.bounding_box.calculate_distance(@current_listing.lat, @current_listing.lon)
  end

  def is_strict_matched?
      puts inside?.to_s + ' | ' +
        (self.price["max"].to_s + " <= " +  @current_listing.price.amount.to_s) + ' | ' + 
        (self.price["min"].to_s + " >= " +  @current_listing.price.amount.to_s) + ' | ' + 
        (self.organizations - @current_listing.organizations.collect(&:id)).empty?.to_s + ' | ' + 
        (self.amenities - @current_listing.amenities.collect(&:id)).empty?.to_s
    inside? && 
      (self.amenities - @current_listing.amenities.collect(&:id)).empty? &&
      (self.organizations - @current_listing.organizations.collect(&:id)).empty? &&
      # 2012-12-20 MKK TODO: how about currency convertion?
      (self.price["max"] ? self.price["max"] <= @current_listing.price.amount : true) &&
      (self.price["min"] ? self.price["min"] >= @current_listing.price.amount : true)
      # 2012-12-20 MKK TODO: quanity for each day

  end

  def inside?
    self.bounding_box.inside?(@current_listing.lat, @current_listing.lon)
  end

  def set_current_listing(listing)
    @current_listing = listing
  end

end

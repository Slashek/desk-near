class ScoreCalculator

  attr_accessor :listings, :bounding_box, :amenities, :organizations, :price, :price_average

  def initialize(params)
    self.bounding_box = BoundingBox.new(params["boundingbox"])
    self.amenities = params["amenities"] ? params["amenities"] : []
    self.organizations = params["organizations"] ? params["organizations"] : []
    self.price = params["price"] ? params["price"] : {}
    validate_price
    define_price_average
    @bounding_box_ranking = {}
    @amenities_ranking = {}
    @organizations_ranking = {}
    @price_ranking = {}
  end

  def calculate_distance_for_listing
    distance =  self.bounding_box.distance_from(@current_listing.lat, @current_listing.lon)
    @bounding_box_ranking[@current_listing.id] = distance
    distance

  end

  def calculate_amenities_matched_for_listing
    amenities_matched = self.amenities.count - (self.amenities - @current_listing.amenities.collect(&:id)).count
    @amenities_ranking[@current_listing.id] = amenities_matched
    amenities_matched
  end

  def calculate_organizations_matched_for_listing
    organizations_matched = self.organizations.count - (self.organizations -  @current_listing.organizations.collect(&:id)).count
    @organizations_ranking[@current_listing.id] = organizations_matched
    organizations_matched
  end

  def calculate_price_diff
    # 2012-12-22 MKK: currency conversion might be required
    price_diff = self.price_average ? (self.price_average - @current_listing.price.amount).abs : 0
    @price_ranking[@current_listing.id] = price_diff
    price_diff
  end

  def is_strict_matched?
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

  def convert_to_rank(hash_with_id_value, order = 'asc')
    @rank_hash = {}
    @rank = 1
    @previous_value = nil
    @order = order
    (hash_with_id_value.sort_by { |id, value| value }).each do |id, value| 
      @previous_value = value if @previous_value.nil? 
      increment_rank_if_needed(value)
      @rank_hash[id] = @rank
      @previous_value = value
    end
    @rank_hash
  end

  def increment_rank_if_needed(value)
    if(@order=='asc')
      if(value > @previous_value)
        @rank += 1
      elsif @order=='desc'
        if(value < @previous_value)
          @rank += 1
        end
      end
    end
  end

  def normalize_rank_hash(rank_hash)
    normalized_rank_hash = {}
    if rank_hash.count > 0
      #2012-12-22 MKK: Specification is not consistent? It says value should be divided by max rank
      # but in the example count is used. For A => 1, B =>1, C => 2, D => 2 it should be 50% and 100%
      # if max is used, but 25% and 50% if count is used [ as in example ]. I give priority to examples
      rank_hash_max = rank_hash.count #rank_hash.values.max
      rank_hash.each do |id, value|
        normalized_rank_hash[id] = ((value*100).to_f/rank_hash_max.to_f)
      end
      normalized_rank_hash
    else
      return {}
    end

  end

  def get_score
    @bounding_box_ranking
  end

  def define_price_average
    self.price_average = nil
    if(self.price)
      if(self.price["min"])
        if(self.price["max"])
          self.price_average = (self.price["min"] + price["max"]).to_f/2
        else
          self.price_average = self.price["min"]
        end
      elsif self.price["max"]
        self.price_average = self.price["max"]
      end
    end
    self.price_average
  end

  def validate_price
    self.price.each do |key, value|
      raise "#{key} price has to be greater than, but #{value} was given" if value < 0 
    end
  end

end

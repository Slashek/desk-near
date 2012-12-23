class ScoreCalculator

  attr_accessor :listings, :bounding_box, :amenities, :organizations, :price, :price_average, :min_quantity, :dates, :quantity

  def initialize(params)
    self.bounding_box = BoundingBox.new(params["boundingbox"])
    self.amenities = params["amenities"] ? params["amenities"].collect{|i| i.to_i} : []
    self.organizations = params["organizations"] ? params["organizations"].collect{|i| i.to_i } : []
    self.price = params["price"] ? params["price"] : {}
    self.dates = params["dates"] ? params["dates"] : []
    self.quantity = params["quantity"] ? params["quantity"] : {}
    validate_price
    define_price_average
    define_min_quantity
    @bounding_box_ranking = {}
    @amenities_ranking = {}
    @organizations_ranking = {}
    @price_ranking = {}
    @availability_ranking = {}
  end

  def calculate_score_for_listing
    calculate_distance_for_listing
    calculate_amenities_matched_for_listing
    calculate_organizations_matched_for_listing
    calculate_price_diff_for_listing
    calculate_availability_for_listing
  end

  def calculate_scores
    @normalized_distance_hash = normalize_rank_hash(convert_to_rank(@bounding_box_ranking))
    @normalized_amenities_hash = normalize_rank_hash(convert_to_rank(@amenities_ranking, 'desc'))
    @normalized_organizations_hash = normalize_rank_hash(convert_to_rank(@organizations_ranking, 'desc'))
    @normalized_price_hash = normalize_rank_hash(convert_to_rank(@price_ranking))
    @normalized_availability_hash = normalize_rank_hash(convert_to_rank(@availability_ranking))
  end

  def calculate_final_score_for_listing(listing)
    #puts "#{@normalized_distance_hash[listing.id]}*0.4 + 
    #{(@normalized_amenities_hash[listing.id] ? @normalized_amenities_hash[listing.id] : 0 )}*0.15 +
    #{(@normalized_organizations_hash[listing.id] ? @normalized_organizations_hash[listing.id] : 0)}*0.15 +
    #{(@normalized_price_hash[listing.id] ? @normalized_price_hash[listing.id] : 0)} *0.15 +
    #{(@normalized_availability_hash[listing.id] ?  @normalized_availability_hash[listing.id] : 0)}*0.15"

    return @normalized_distance_hash[listing.id]*0.4 + 
      (@normalized_amenities_hash[listing.id] ? @normalized_amenities_hash[listing.id] : 0 )*0.15 +
      (@normalized_organizations_hash[listing.id] ? @normalized_organizations_hash[listing.id] : 0)*0.15 +
      (@normalized_price_hash[listing.id] ? @normalized_price_hash[listing.id] : 0) *0.15 +
      (@normalized_availability_hash[listing.id] ?  @normalized_availability_hash[listing.id] : 0)*0.15
  end

  def calculate_distance_for_listing
    distance =  self.bounding_box.distance_from(@current_listing.lat, @current_listing.lon)
    @bounding_box_ranking[@current_listing.id] = distance
    distance
  end

  def calculate_amenities_matched_for_listing
    amenities_matched = self.amenities.count - (self.amenities - @current_listing.amenities.collect(&:id)).count
    #puts @current_listing.name + " " + amenities_matched.to_s
    #puts "#{self.amenities.count} - #{(self.amenities - @current_listing.amenities.collect(&:id)).count } (#{self.amenities.to_s} - #{@current_listing.amenities.collect(&:id).to_s}).count"
    @amenities_ranking[@current_listing.id] = amenities_matched
    amenities_matched
  end

  def calculate_organizations_matched_for_listing
    organizations_matched = self.organizations.count - (self.organizations -  @current_listing.organizations.collect(&:id)).count
    @organizations_ranking[@current_listing.id] = organizations_matched
    organizations_matched
  end

  def calculate_availability_for_listing
    availability_hash = {}
    score = 0
    dates_count = self.dates.count
    if dates_count == 0
      return {}
    else
      @current_listing.availabilities.where(:date => self.dates).each do |availability|
        availability_hash[availability.date.to_s] = availability.quantity.to_i
      end
      (self.dates).each do |date|
        available_in_day = availability_hash[date.to_s] ? availability_hash[date.to_s].to_i : 0
        score += available_in_day.to_f >= self.min_quantity.to_f ? 0 : (self.min_quantity.to_f - available_in_day.to_f)/self.min_quantity.to_f # it is ensured that min_quantity cannot be = 0
      end
      @availability_ranking[@current_listing.id] = score
      score
    end
  end

  def calculate_price_diff_for_listing
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
    (self.price["min"] ? self.price["min"] >= @current_listing.price.amount : true) &&
    (self.dates ? (self.dates.collect{ |date| date.to_s } - @current_listing.availabilities.where(:date => self.dates).collect{|av| av.date.to_s }).empty? : true ) &&
    (self.dates && self.quantity["min"] ? (@current_listing.availabilities.where(:date => self.dates).collect(&:quantity).min ? (self.quantity["min"].to_i <= @current_listing.availabilities.where(:date => self.dates).collect(&:quantity).min) : true ) : true )
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
    sorted_array = @order=='asc' ? (hash_with_id_value.sort { |a, b| a[1].to_f <=> b[1].to_f }) : (hash_with_id_value.sort { |a, b| b[1].to_f<=>a[1].to_f })
    sorted_array.each do |id, value| 
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
      end
    elsif @order=='desc'
      if(value < @previous_value)
        @rank += 1
      end
    end
  end

  def normalize_rank_hash(rank_hash)
    normalized_rank_hash = {}
    if rank_hash.count > 0
      #2012-12-22 MKK: Specification is not consistent? It says value should be divided by max rank
      # but in the example count is used instead. For A => 1, B =>1, C => 2, D => 2 it should be 50% and 100%
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
      self.price[key] = value.to_f
      value = value.to_f
      raise "#{key} price has to be greater than, but #{value} was given" if value < 0 
    end
  end

  def define_min_quantity
    self.min_quantity = 1
    if self.quantity && self.quantity["min"]
      self.min_quantity = self.quantity["min"].to_f
    end
  end

end

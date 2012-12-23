class BoundingBox
  attr_accessor :top_left, :bottom_right, :listing_cache, :center

  def initialize(hash)
    valid?(hash)
    self.top_left = hash["start"]
    hash["start"].each do |k, v|
      self.top_left[k] = v.to_f
    end
    self.bottom_right = hash["end"]
    hash["end"].each do |k, v|
      self.bottom_right[k] = v.to_f
    end
    self.center = {
      "lat" => (hash["start"]["lat"].to_f + hash["end"]["lat"].to_f)/2,
      "lon" => (hash["start"]["lon"].to_f + hash["end"]["lon"].to_f)/2}
  end

  def includes_listing?(listing)
    listing_in_box?(listing)
  end

  def inside?(lat, lon)
     lat = lat.to_f
     lon = lon.to_f
     if lat >= self.bottom_right["lat"] 
         if lat <= self.top_left["lat"] 
           if lon >= self.bottom_right["lon"] 
             if lon <= self.top_left["lon"]
               return true
             end
           end
         end
     end
     return false
  end

  def listing_in_box?(listing)
    raise 'Listing must have filled lat and lon fields' unless listing.lat && listing.lon
    inside?(listing.lat, listing.lon)
  end

  def distance_from(lat, lon)
    return (lat - self.center["lat"]).abs + (lon - self.center['lon']).abs
  end

  def valid?(hash)
    raise 'Boundingbox parameter is required' if !hash.is_a?(Hash)
    raise 'No start key found while creating BoundingBox' if !hash["start"]
    raise 'No end key found while creating BoundingBox' if !hash["end"]
    raise 'BoundingBox does not have specified start point correctly - "start" => { "lat" => X, "lat" -> Y}' unless hash["start"]["lat"] && hash["start"]["lon"]
    raise 'BoundingBox does not have specified end point correctly - "end" => { "lat" => X, "lat" -> Y}' unless hash["end"]["lat"] && hash["end"]["lon"]
  end
end

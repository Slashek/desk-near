class BoundingBox
  attr_accessor :top_left, :bottom_right, :listing_cache

  def initialize(hash)
    valid?(hash)
    self.top_left = hash["start"]
    self.bottom_right = hash["end"]
  end

  def includes_listing?(listing)
    listing_in_box?(listing)
  end

  def inside?(lat, lon)
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

  def valid?(hash)
    raise 'Argument is not a hash' if !hash.is_a?(Hash)
    raise 'No start key found while creating BoundingBox' if !hash["start"]
    raise 'No end key found while creating BoundingBox' if !hash["end"]
    raise 'BoundingBox does not have specified start point correctly - "start" => { "lat" => X, "lat" -> Y}' unless hash["start"]["lat"] && hash["start"]["lon"]
    raise 'BoundingBox does not have specified end point correctly - "end" => { "lat" => X, "lat" -> Y}' unless hash["end"]["lat"] && hash["end"]["lon"]
  end
end

require 'spec_helper'

describe ListingsController do

  before do
    @params = {
      "boundingbox"=> {
      "start"=> {
      "lat"=> 37.791049,
      "lon"=> -122.399540
    },
      "end"=> {
      "lat"=> 37.780603,
      "lon"=> -122.413273
    }
    },
      "location"=> {
      "lat"=> 37.0,
      "lon"=> 128.0
    },
      "dates"=> ["2012-06-01", "2012-06-15"],
      "quantity"=> {
      "min"=> 5,
      "max"=> 12
    },
      "price"=> {
      "min"=> 25.00
    },
      "amenities"=> [ 1, 5 ],
      "organizations"=> [ 1, 2, 3 ]
    }
  end


end

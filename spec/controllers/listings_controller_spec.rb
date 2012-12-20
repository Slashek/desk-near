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

  describe "POST 'search'" do
    it "throws error without boundingbox parameter" do
      #lambda { post 'search', :format => :json }.should raise_error
    end

    it "throws error if boundingbox parameter is empty array" do
      #lambda { post 'search', :format => :json, :boundingbox => {} }.should raise_error
    end

    it "returns http success" do
      #post 'search', :format => :json
    end

    it "returns listing" do
      # 2012-12-20 MKK TODO: google why objects are not deleted automagically
      Listing.destroy_all
      @maciek = FactoryGirl::create(:listing_maciek)
      @faraway = FactoryGirl::create(:listing_faraway)
      post 'search', :format => :json, :boundingbox => {
          "start"=> {
            "lat"=> 10,
            "lon"=> 10
          },
          "end"=> {
            "lat"=> -10,
            "lon"=> -10
          }
        },
        :location => {
          "lat"=> 5,
          "lon"=> 0
        },
        :dates=> ["2012-06-01", "2012-06-15"],
        :quantity => {
          "min"=> 5,
          "max"=> 12
        },
        :price=> {
          "min"=> 25.00
        },
        :amenities=> [ 1, 5 ],
        :organizations=> [ 1, 2, 3 ]

      #actual = JSON.parse(@response.body)

      #assert_equal(Listing.collection_to_json([@maciek, @faraway]), actual )
    end

  end

end

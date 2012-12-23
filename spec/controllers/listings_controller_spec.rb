require 'spec_helper'

describe ListingsController do

  before(:each) do
    @listing_maciek = FactoryGirl.create(:listing_maciek)

    @listing_faraway = FactoryGirl.create(:listing_faraway)
    @listing_faraway.amenities = [@listing_maciek.amenities[0]]
    @listing_faraway.price.amount = @listing_maciek.price.amount - 10
    @listing_faraway.lat = @listing_maciek.lat + 8.01
    @listing_faraway.lon = @listing_maciek.lat - 8.01
    @listing_faraway.organizations = []
    @listing_faraway.organizations = [@listing_maciek.organizations[0], @listing_maciek.organizations[1]]
    @listing_faraway.price.save
    @listing_faraway.availabilities = []
    @listing_faraway.availabilities << Availability.create('date' => @listing_maciek.availabilities[0].date, 'quantity' => @listing_maciek.availabilities[0].quantity)
    @listing_faraway.availabilities << Availability.create('date' => @listing_maciek.availabilities[2].date, 'quantity' => @listing_maciek.availabilities[2].quantity)
    @listing_faraway.save

    @listing_with_wifi_foosball = FactoryGirl.create(:listing_with_wifi_foosball)
    @listing_with_wifi_foosball.amenities = [@listing_maciek.amenities[0], @listing_maciek.amenities[1]]
    @listing_with_wifi_foosball.organizations = []
    @listing_with_wifi_foosball.organizations = [@listing_maciek.organizations[0], @listing_maciek.organizations[2]]
    @listing_with_wifi_foosball.price.amount = @listing_maciek.price.amount - 5 # no strict match
    @listing_with_wifi_foosball.price.save
    @listing_with_wifi_foosball.availabilities = []
    @listing_with_wifi_foosball.availabilities << Availability.create('date' => @listing_maciek.availabilities[0].date, 'quantity' => @listing_maciek.availabilities[0].quantity-1)
    @listing_with_wifi_foosball.lat = @listing_maciek.lat + 4.55
    @listing_with_wifi_foosball.lon = @listing_maciek.lat - 4.41
    @listing_with_wifi_foosball.save

    # boudning box rank:
    #
    # maciek: 1
    # faraway: 3 
    # wifi_foosball: 2 
    #
    # availabilities:
    #
    # maciek: 1
    # faraway: 2
    # wifi_foosball: 3
    #
    # price:
    #
    # maciek: 3
    # listing_faraway: 1
    # with_foosball: 2
    #
    # organizations
    #
    # maciek: 1
    # faraway: 2
    # wifi_foosball: 2
    #
    # amenities:
    #
    # maciek: 1
    # faraway: 3
    # wifi_foosball: 2
    #
    # maciek:
    # 33 * 0.4 + 33 * 0.15 + 100 * 0.15 + 33 * 0.15 = 43.33
    @params = {
      "boundingbox"=> {
      "start"=> {
      "lat"=> @listing_maciek.lat+2,
      "lon"=> @listing_maciek.lon+2
    },
      "end"=> {
      "lat"=> @listing_maciek.lat-1.225,
      "lon"=> @listing_maciek.lon-1.434
    }
    },
      # ignored for now?
      "location"=> {
      "lat"=> 37.0,
      "lon"=> 128.0
    },
      "dates"=> @listing_maciek.availabilities.collect(&:date),
      "quantity"=> {
      "min"=> 1
    },
      "price"=> {
      "max"=> @listing_maciek.price.amount - 10
    },
      "amenities"=> @listing_maciek.amenities.collect(&:id),
      "organizations"=> @listing_maciek.organizations.collect(&:id)
    }
  end

  context 'with boudning box parameter' do

    it 'gets 200 response from post listings/search' do
      post :search,  @params
      assert_equal(200, response.status)
    end

    it 'obtains results with the right score' do
      post :search, @params
      actual = JSON.parse(response.body)
      puts actual.class.to_s
      actual_scores = []
      actual["listings"].each do |listing|
        actual_scores << listing["score"].to_f.round(2)
      end
      expected_score = [43.33, 71.67, 80.0] # should use be_within or something similar
      assert_equal(expected_score, actual_scores)
    end

    it 'requires only boundingbox' do
      post :search, :boundingbox => @params["boundingbox"]
      actual = JSON.parse(response.body)
      actual_scores = []
      actual["listings"].each do |listing|
        actual_scores << listing["score"].to_f.round(2)
      end
      expected_score = [13.33, 26.67, 40.0] # should use be_within or something similar
      assert_equal(expected_score, actual_scores)
    end

    it 'returns listings in the right order' do
      post :search, :boundingbox => @params["boundingbox"]
      actual = JSON.parse(response.body)
      actual_scores = []
      actual["listings"].each do |listing|
        actual_scores << listing["name"]
      end
      expected_score = [@listing_maciek.name,@listing_with_wifi_foosball.name, @listing_faraway.name ] # should use be_within or something similar
      assert_equal(expected_score, actual_scores)
    end
  end

  context 'without boudning box parameter' do
    it 'requires bounding box parameter' do
      lambda { post :search}.should raise_error

    end
  end

end

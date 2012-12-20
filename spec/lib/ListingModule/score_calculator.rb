require 'spec_helper'

describe ScoreCalculator do

  before do
    @score_calculator = ScoreCalculator.new(
      {
      "boundingbox"=> {
      "start"=> {
      "lat"=> 10,
      "lon"=> 10
    },
      "end"=> {
      "lat"=> -10,
      "lon"=> -10
    }
    },
      "location"=> {
      "lat"=> 5,
      "lon"=> 5
    },
      "dates"=> ["2012-06-01", "2012-06-15"],
      "quantity"=> {
      "min"=> 5,
      "max"=> 12
    },
    })
    @listing_maciek = FactoryGirl.create(:listing_maciek)
    @listing_faraway = FactoryGirl.create(:listing_faraway)
  end

  describe 'computes strict_match' do

    context 'listing inside boundbox' do

      before do 
        @score_calculator.set_current_listing(@listing_maciek)
      end

      it 'is true if nothing else is specified' do
        @score_calculator.is_strict_matched?
      end

      it 'is true if all amenities are in' do
        @score_calculator.amenities = 
        assert_equal(true, @score_calculator.is_strict_matched?)
      end

      it 'is false if not all amenities are in' do
        @score_calculator.amenities = @listing_maciek.amenities.collect(&:id) << 100
        assert_equal(false, @score_calculator.is_strict_matched?)
      end

      it 'is true if all organizations are in' do
        @score_calculator.organizations = @listing_maciek.organizations.collect(&:id)
        assert_equal(true,  @score_calculator.is_strict_matched?)
      end

      it 'is false if not all organizations are in' do
        @score_calculator.organizations = @listing_maciek.organizations.collect(&:id) << 100
        assert_equal(false, @score_calculator.is_strict_matched?)
      end

      it 'is true if price equal to max' do
        @score_calculator.price =  {"max" => @listing_maciek.price.amount }
        assert_equal(true, @score_calculator.is_strict_matched?)
      end

      it 'is true if price lower than max' do
        @score_calculator.price =  {"max" => @listing_maciek.price.amount-1 }
        assert_equal(true, @score_calculator.is_strict_matched?)
      end

      it 'is false if price greater than max' do
        @score_calculator.price =  {"max" => @listing_maciek.price.amount+1 }
        assert_equal(false, @score_calculator.is_strict_matched?)
      end

      it 'is true if price equal to min' do
        @score_calculator.price =  {"min" => @listing_maciek.price.amount }
        assert_equal(true, @score_calculator.is_strict_matched?)
      end

      it 'is true if price greater than min' do
        @score_calculator.price =  {"min" => @listing_maciek.price.amount+1 }
        assert_equal(true, @score_calculator.is_strict_matched?)
      end

      it 'is false always' do
        @score_calculator.price =  {"min" => @listing_maciek.price.amount-1 }
        assert_equal(false, @score_calculator.is_strict_matched?)
      end

    end

    context 'listing outside boundbox' do

      before do 
        @score_calculator.set_current_listing(@listing_faraway)
      end

      it 'is false if nothing else is specified' do
        assert_equal(false, @score_calculator.is_strict_matched?)
      end


    end
  end

  context 'calculating boundingbox ranking' do
    it 'should calculate distance from user\'s location to listing' do
      #assert_equal(5, @score_calculator.calculate_distance_for_listing(@score_calculator))
    end

    it 'takes into consideration latitude lower than zero' do
      #assert_equal(145, @score_calculator.calculate_distance_for_listing(@listing_faraway))
    end
  end


end

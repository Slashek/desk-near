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

  describe 'calculates score' do

    it 'calculates amenities ranking' do
      @score_calculator.amenities = @listing_maciek.amenities.collect(&:id)
      @score_calculator.set_current_listing(@listing_maciek)
      assert_equal(3, @score_calculator.calculate_amenities_matched_for_listing)
      @listing_maciek.amenities = [@listing_maciek.amenities[0], @listing_maciek.amenities[1]]
      assert_equal(2,  @score_calculator.calculate_amenities_matched_for_listing)
      @listing_faraway.amenities = [@listing_maciek.amenities[0]]
      @score_calculator.set_current_listing(@listing_faraway)
      assert_equal(1, @score_calculator.calculate_amenities_matched_for_listing)
    end

    it 'calculates organizations ranking' do
      @score_calculator.organizations = @listing_maciek.organizations.collect(&:id)
      @score_calculator.set_current_listing(@listing_maciek)
      assert_equal(3, @score_calculator.calculate_organizations_matched_for_listing)
      @listing_maciek.organizations = [@listing_maciek.organizations[0], @listing_maciek.organizations[1]]
      assert_equal(2,  @score_calculator.calculate_organizations_matched_for_listing)
      @listing_faraway.organizations = [@listing_maciek.organizations[0]]
      @score_calculator.set_current_listing(@listing_faraway)
      assert_equal(1, @score_calculator.calculate_organizations_matched_for_listing)
    end

    it 'calculates price ranking' do
      @score_calculator.price = {"max" => 10.25, "min" => -5.75}
      @score_calculator.define_price_average
      @score_calculator.set_current_listing(@listing_maciek)
      assert_equal(72.75, @score_calculator.calculate_price_diff)
    end

    it 'calculating boundingbox ranking' do
      @score_calculator.set_current_listing(@listing_faraway)
      assert_equal(150.0, @score_calculator.calculate_distance_for_listing)
      @score_calculator.set_current_listing(@listing_maciek)
      assert_equal(5.0, @score_calculator.calculate_distance_for_listing)
    end

  end

  describe 'converts hash id value to id rank' do

    context 'with asc order' do

      it 'can assign different rank for each object' do
        assert_equal({1 => 1, 3 => 2, 2 => 3}, @score_calculator.convert_to_rank({1 => 10 , 2 => 30, 3 => 20}))
      end

      it 'can assign same rank to multiple objects' do
        assert_equal({1 => 1, 2 => 1, 3 => 2}, @score_calculator.convert_to_rank({1 => 10 , 2 => 10, 3 => 20}))
      end

      it 'can assign same rank to all objects' do
        assert_equal({1 => 1, 2 => 1, 3 => 1}, @score_calculator.convert_to_rank({1 => 10 , 2 => 10, 3 => 10}))
      end

      it 'does not raise exception for empty hash' do
        assert_equal({}, @score_calculator.convert_to_rank({}))
      end

    end

  end

  describe 'converts rank hash to score hash' do

    it 'can normalize hash with different rank for each object' do
      assert_equal({1 => 25.00, 2 => 100.00, 3 => 50.00, 4 => 75.00}, @score_calculator.normalize_rank_hash({1 => 1, 2 => 4, 3 => 2, 4 => 3}))
    end

    it 'can normalize hash with same rank for some objects' do
      assert_equal({1 => 25.00, 2 => 25.00, 3 => 50.00, 4 => 50.00}, @score_calculator.normalize_rank_hash({1 => 1, 2 => 1, 3 => 2, 4 => 2}))
    end
  end

  describe  'defines price_average' do

    before do
      @score_calculator.price = {}
    end

    it 'use only min if no max' do
      @score_calculator.price = {"min" => 10}
      assert_equal(10, @score_calculator.define_price_average)
    end
    
    it 'use only max if no min' do
      @score_calculator.price = {"max" => 10}
      assert_equal(10, @score_calculator.define_price_average)
    end
    
    it 'calculates average if max and min' do
      @score_calculator.price = {"max" => 10, "min" => 0}
      assert_equal(5, @score_calculator.define_price_average)
    end

    it 'works for decimal' do
      @score_calculator.price = {"max" => 10.25, "min" => 5.55}
      assert_equal(7.9, @score_calculator.define_price_average)
    end

  end


end

require 'spec_helper'

describe BoundingBox do
  before do
    @listing = FactoryGirl.create(:listing_maciek)
      @bounding_box = BoundingBox.new({"start" => {"lat" => 10, "lon" => 10}, "end" => {"lat" => -10, "lon" => -10}})
  end

  context 'point located in ' do

    it 'center is inside' do
       assert_equal(true, @bounding_box.inside?(0,0))
    end
    
    it 'top left corner is inside' do
       assert_equal(true,  @bounding_box.inside?(10,10))
    end
    
    it 'bottom right corner is inside' do
       assert_equal(true,  @bounding_box.inside?(-10,-10))
    end
  
    it 'top right corner is inside' do
       assert_equal(true, @bounding_box.inside?(10,-10))
    end

    it 'bottom left corne is inside' do
       assert_equal(true, @bounding_box.inside?(-10,10))
    end

    it 'one off lat from bottom right corner is outside' do
       assert_equal(false, @bounding_box.inside?(-11,-10))
    end

    it 'one off lon from bottom right corner is outside' do
       assert_equal(false, @bounding_box.inside?(-10,-11))
    end
    
    it 'one off lon and lan from bottom right corner is outside' do
       assert_equal(false, @bounding_box.inside?(-11,-11))
    end

    it 'one off lon and lan from top right corner is outside' do
       assert_equal(false,  @bounding_box.inside?(10,-11))
    end

  end

    it 'has defined center' do
      assert_equal({"lat" => 0, "lon" => 0}, @bounding_box.center)
    end

    context 'should define distance from center' do
    it 'calcultes distance from plus lat minus lon' do
      assert_equal(20, @bounding_box.distance_from(10, -10))
    end

    it 'calcaltes distance from plus lat plus lon' do
      assert_equal(20, @bounding_box.distance_from(15, 5))
    end

    it 'calcaltes distance from minus lat minus lon' do
      assert_equal(20, @bounding_box.distance_from(-15, -5))
    end

    it 'calcaltes distance from minus lat plus lon' do
      assert_equal(20, @bounding_box.distance_from(-15, 5))
    end

    end
end

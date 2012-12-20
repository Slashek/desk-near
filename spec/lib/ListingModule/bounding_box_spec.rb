require 'spec_helper'

describe BoundingBox do
  before do
    @listing = FactoryGirl.create(:listing_maciek)
  end

  context 'point located in '

    before do
      @bounding_box = BoundingBox.new({"start" => {"lat" => 10, "lon" => 10}, "end" => {"lat" => -10, "lon" => -10}})
    end

    it 'center is inside' do
       res = @bounding_box.inside?(0,0)
       assert_equal(true, res)
    end
    
    it 'top left border is inside' do
       res = @bounding_box.inside?(10,10)
       assert_equal(true, res)
    end
    
    it 'bottom right border is inside' do
       res = @bounding_box.inside?(-10,-10)
       assert_equal(true, res)
    end
  
    it 'top right border is inside' do
       res = @bounding_box.inside?(10,-10)
       assert_equal(true, res)
    end

    it 'bottom left border is inside' do
       res = @bounding_box.inside?(-10,10)
       assert_equal(true, res)
    end

    it 'one off lat from bottom right border is outside' do
       res = @bounding_box.inside?(-11,-10)
       assert_equal(false, res)
    end

    it 'one off lon from bottom right border is outside' do
       res = @bounding_box.inside?(-10,-11)
       assert_equal(false, res)
    end
    
    it 'one off lon and lan from bottom right border is outside' do
       res = @bounding_box.inside?(-11,-11)
       assert_equal(false, res)
    end

    it 'one off lon and lan from top right border is outside' do
       res = @bounding_box.inside?(10,-11)
       assert_equal(false, res)
    end

end

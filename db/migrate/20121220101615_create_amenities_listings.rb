class CreateAmenitiesListings < ActiveRecord::Migration
  def change
    create_table :amenities_listings do |t|
      t.integer :amenity_id
      t.integer :listing_id
    end
  end
end

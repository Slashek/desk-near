class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.float :score
      t.boolean :strict_match
      t.string :name
      t.string :description
      t.string :address
      t.float :lat
      t.float :lon
      t.integer :quantity
      t.string :web_listing_url
      t.string :api_listing_url
      t.string :api_rating_url
      t.string :api_connections_url
      t.string :api_patrons_url
      t.string :api_availability_url
      t.string :api_reservation_url

      t.timestamps
    end
  end
end

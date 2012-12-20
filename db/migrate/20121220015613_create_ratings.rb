class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.float :average
      t.integer :count
      t.integer :listing_id

      t.timestamps
    end
  end
end

class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.integer :listing_id
      t.date :date
      t.integer :quantity

      t.timestamps
    end
  end
end

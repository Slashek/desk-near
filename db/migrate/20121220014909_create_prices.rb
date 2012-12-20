class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.float :amount
      t.string :label
      t.string :currency_code
      t.string :period
      t.integer :listing_id

      t.timestamps
    end
  end
end

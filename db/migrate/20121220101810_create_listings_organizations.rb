class CreateListingsOrganizations < ActiveRecord::Migration
  def change
    create_table :listings_organizations do |t|
      t.integer :organization_id
      t.integer :listing_id
    end
  end
end

class RemoveScoreAndStrictMatchFromListing < ActiveRecord::Migration
  def up
    remove_column :listings, :score
    remove_column :listings, :strict_match
  end

  def down
    add_column :listings, :strict_match, :boolean
    add_column :listings, :score, :float
  end
end

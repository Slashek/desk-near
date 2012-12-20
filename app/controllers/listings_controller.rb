class ListingsController < ApplicationController
  def search
    
    respond_to do |format|
      # 2012-12-20 Maciek TODO: include pagination
      format.json { render json: Listing.collection_to_json( Listing.find_all_based_on_search(params) ) } 
    end
  end
end

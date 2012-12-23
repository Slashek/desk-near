class ListingsController < ApplicationController

  def search
    respond_to do |format|
      # 2012-12-20 Maciek TODO: change default format to JSON
      format.html { render json: { :listings => Listing.find_all_based_on_search(params) } }
      format.json { render json: { :listings => Listing.find_all_based_on_search(params) } } 
    end
  end
end

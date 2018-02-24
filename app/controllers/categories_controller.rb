class CategoriesController < ApplicationController
    def search
    	if params[:keyword] != ''
	  	  	@categories = Category.where('name LIKE(?)', "#{params[:keyword]}%").or(Category.where('hira LIKE(?)', "#{params[:keyword]}%")).or(Category.where('kana LIKE(?)', "#{params[:keyword]}%"))
	  	  	respond_to do |format|
	  	  		format.json { render 'index', json: @categories }
	  	  	end
	  	end
  	end
end
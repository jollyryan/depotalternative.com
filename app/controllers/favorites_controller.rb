class FavoritesController < ApplicationController
  # GET /favorites
  # GET /favorites.xml
  def index
    @favorites = current_user.favorites.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @favorites }
    end
  end

  # POST /favorites
  # POST /favorites.xml
  def create
    @favorite = current_user.favorites.new
    @favorite.supplier_id = params[:id]
    @supplier = Supplier.find(params[:id])

    respond_to do |format|
      if @favorite.save
        format.html { redirect_to(@supplier, :notice => 'Favorite was successfully created.') }
      else
        format.html { redirect_to(@supplier, :alert => 'Whoa! Already a favorite.') }
      end
    end
  end

  # DELETE /favorites/1
  # DELETE /favorites/1.xml
  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy

    respond_to do |format|
      format.html { redirect_to(favorites_url) }
      format.xml  { head :ok }
    end
  end
end

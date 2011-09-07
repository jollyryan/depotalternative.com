class SuppliersController < ApplicationController
  load_and_authorize_resource
  
  layout :choose_layout
  
  # GET /suppliers
  # GET /suppliers.xml
  
  before_filter :authenticate_user!, :except=> [:show, :index]
  
  def index

    @specialties = Specialty.all
    @suppliers = Supplier.filter(params[:state], params[:city_id], params[:specialty_id], 20, params[:page])
    @results = Supplier.get_results(params[:state], params[:city_id], params[:specialty_id])
    @cities = City.find_all_by_state(params[:state])

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @suppliers }
    end
  end

  #def get_cities
  #  @cities = City.find_all_by_state(params[:state])
  #  render :update do |page|
  #    page.replace_html('cities_search', :partial => 'cities')
  #  end
  #end

  # GET /suppliers/1
  # GET /suppliers/1.xml
  def show
    @supplier = Supplier.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @supplier }
    end
  end
  
  # GET /suppliers/1
  # GET /suppliers/1.xml
  def print
    @supplier = Supplier.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @supplier }
    end
  end

  # GET /suppliers/new
  # GET /suppliers/new.xml
  def new
    @supplier = current_user.suppliers.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @supplier }
    end
  end

  # GET /suppliers/1/edit
  def edit
    @supplier = Supplier.find(params[:id])
  end

  # POST /suppliers
  # POST /suppliers.xml
  def create
    @supplier = current_user.suppliers.new(params[:supplier])
    @specialty = Specialty.find(@supplier.specialty_id)
    @city = City.find(@supplier.city_id)


    respond_to do |format|
      if @city.suppliers << @supplier && @specialty.suppliers << @supplier
        format.html { redirect_to(@supplier, :notice => 'Supplier was successfully created.') }
        format.xml  { render :xml => @supplier, :status => :created, :location => @supplier }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @supplier.errors, :status => :unprocessable_entity }
      end
    end

  end

  # PUT /suppliers/1
  # PUT /suppliers/1.xml
  def update
    @supplier = Supplier.find(params[:id])
    @city = City.find(@supplier.city_id)
    @specialty = Specialty.find(@supplier.specialty_id)

    respond_to do |format|
      if @supplier.update_attributes(params[:supplier]) #&& @city.suppliers << @supplier && @specialty.suppliers << @supplier
        format.html { redirect_to(@supplier, :notice => 'Supplier was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @supplier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.xml
  def destroy
    @supplier = current_user.suppliers.find(params[:id])
    @supplier.destroy

    respond_to do |format|
      format.html { redirect_to(suppliers_url, :notice => 'Supplier was successfully deleted.') }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def choose_layout
    if current_user && params[:print] == "true"
      "print"
    else
      "application"
    end
  end
end

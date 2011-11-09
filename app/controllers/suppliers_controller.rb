class SuppliersController < ApplicationController
  load_and_authorize_resource
  
  # GET /suppliers
  # GET /suppliers.xml
  
  before_filter :authenticate_user!, :except=> [:show, :index]
  
  def index

    @specialties = Specialty.all
    @suppliers = Supplier.filter(params[:state_id], params[:city_id], params[:specialty_id], 20, params[:page])
    @results = Supplier.get_results(params[:state_id], params[:city_id], params[:specialty_id])
    @states = State.all
    @cities = City.find_all_by_state_id(params[:state_id])

    respond_to do |format|
      format.html # index.html.erb
      format.js
      format.xml  { render :xml => @suppliers }
    end
  end


  # GET /suppliers/1
  # GET /suppliers/1.xml
  def show
    @supplier = Supplier.find(params[:id])

    @click = Click.new(@supplier.id)

    if @supplier.clicks << @click
      @clicks_this_month = Click.clicks_this_month Date.today


      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @supplier }
      end
    end
  end

  # GET /suppliers/new
  # GET /suppliers/new.xml
  def new
    @states = State.all
    @cities = City.find_all_by_state_id(params[:id])
    @supplier = current_user.suppliers.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @supplier }
    end
  end


  # GET /suppliers/1/edit
  def edit

    @supplier = current_user.suppliers.find(params[:id])
    @state = State.find(@supplier.city.state)
    @cities = City.find_all_by_state_id(@state.id)
    @states = State.all
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
        #@states = State.all
        #@cities = City.find_all_by_state_id(params[:state_id])
        format.html { render :action => "new" }
        format.xml  { render :xml => @supplier.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /suppliers/1
  # PUT /suppliers/1.xml
  def update
    @supplier = current_user.suppliers.find(params[:id])
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
    @supplier = Supplier.find(params[:id])
    @supplier.destroy

    respond_to do |format|
      format.html { redirect_to(suppliers_url) }
      format.xml  { head :ok }
    end
  end
end

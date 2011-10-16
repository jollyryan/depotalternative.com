class CitiesController < ApplicationController
    
    load_and_authorize_resource
  
    # GET /cities
    # GET /cities.xml
    def index
      @cities = City.all

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @cities }
      end
    end

    # GET /cities/1
    # GET /cities/1.xml
    def show
      @city = City.find(params[:id])
      @state = State.find(@city.state_id)

      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @city }
      end
    end

    # GET /cities/new
    # GET /cities/new.xml
    def new
      @city = City.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @city }
      end
    end

    # GET /cities/1/edit
    def edit
      @city = City.find(params[:id])
    end

    # POST /cities
    # POST /cities.xml
    def create
      @city = City.new(params[:city])
      @state = State.find(params[:state_id])

      respond_to do |format|
        if @state.cities << @city
          format.html { redirect_to(@city, :notice => 'City was successfully created.') }
          format.xml  { render :xml => @city, :status => :created, :location => @city }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
        end
      end
    end

    # PUT /cities/1
    # PUT /cities/1.xml
    def update
      @city = City.find(params[:id])

      respond_to do |format|
        if @city.update_attributes(params[:city])
          format.html { redirect_to(@city, :notice => 'City was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
        end
      end
    end

    # DELETE /cities/1
    # DELETE /cities/1.xml
    def destroy
      @city = City.find(params[:id])
      @city.destroy

      respond_to do |format|
        format.html { redirect_to(cities_url) }
        format.xml  { head :ok }
      end
    end

    def for_stateid
      @cities = City.find_all_by_state_id(params[:id]).sort_by{ |k| k['city_name']}
      respond_to do |format|
        format.json  { render :json => @cities }
      end
    end

end

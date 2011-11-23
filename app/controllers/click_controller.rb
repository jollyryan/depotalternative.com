class ClickController < ApplicationController

    # GET /click/new
    # GET /click/new.xml
    def new
      @click = Click.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @city }
      end
    end

    # POST /click
    # POST /click.xml
    def create
      @click = Click.new(params[:click])
      @supplier = Supplier.find(params[:supplier_id])

      if @supplier.clicks << @click

      end

    end
end

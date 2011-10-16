class Supplier < ActiveRecord::Base
  attr_accessible :city_id, :specialty_id, :uploaded_file, :name, :description, :address, :phone_number, :email

  belongs_to :city
  belongs_to :specialty
  belongs_to :user

  has_many :clicks

  validates :name, :city_id, :specialty_id, :presence => true

  #set up "uploaded_file" field as attached_file (using Paperclip)
  has_attached_file :uploaded_file,
                    :path => "suppliers/:id/:style/:basename.:extension",
                    :storage => :s3,
                    :s3_credentials => "#{Rails.root}/config/amazon_s3.yml",
                    :bucket => "depotalternative",
                    :styles => {
                        :thumbnail => "150x150>",
                        :normal    => "800x800>"
                    }


  validates_attachment_size :uploaded_file, :less_than => 10.megabytes
  #validates_attachment_presence :uploaded_file
  validates_attachment_content_type :uploaded_file, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  def file_name
    uploaded_file_file_name
  end

  def self.filter(state_id, city_id, specialty_id, per_page, page)

      #IF NOT CHOOSE A STATE, RETURN ALL SUPPLIERS EVERYWHERE
    if state_id != nil && state_id != '--Select a State--'
       @state = State.find(state_id)
       #IF CHOOSE STATE, GET CITIES OF THAT STATE
       @cities = @state.cities
       #IF CITY SELECTED, GET SUPPLIERS FOR THAT CITY AND STATE ONLY
       if city_id != nil && city_id != ''
         @chosen_city = City.find_by_id(city_id)
         #IF SPECIALTY SELECTED, GET SUPPLIERS WITH THAT SPECIALTY ONLY IN THAT CITY AND STATE
         if specialty_id != nil && specialty_id != ''
           if @cities.include?(@chosen_city)
             find_by_sql("SELECT * FROM suppliers WHERE city_id = " + @chosen_city.id.to_s + " AND specialty_id = " + specialty_id).paginate(:per_page => per_page, :page => page)
           else
             find_by_sql("SELECT * FROM suppliers s, cities c WHERE s.city_id = c.id AND c.state_id = " + @state.id.to_s + " AND specialty_id = " + specialty_id).paginate(:per_page => per_page, :page => page)
           end
         else
           #TEMPORARY SOLUTION UNTIL REFRESH CITY DROPDOWN ON STATE CHANGE
           if @cities.include?(@chosen_city)
             @chosen_city.suppliers.paginate(:per_page => per_page, :page => page)
           else
             find_by_sql("SELECT * FROM suppliers s, cities c WHERE s.city_id = c.id AND c.state_id = " + @state.id.to_s).paginate(:per_page => per_page, :page => page)
           end
         end

       #IF NO CITY SELECTED AND SPECIALTY SELECTED, DISPLAY SUPPLIERS WITH THAT SPECIALTY IN THAT STATE
       elsif specialty_id != nil && specialty_id != ''
         find_by_sql("SELECT * FROM suppliers s, cities c WHERE s.city_id = c.id AND c.state_id = " + @state.id.to_s + " AND s.specialty_id = " + specialty_id).paginate(:per_page => per_page, :page => page)
       #IF NO CITY OR SPECIALTY SELECTED, RETURN ALL SUPPLIERS IN SELECTED STATE
       else
          find_by_sql("SELECT * FROM suppliers s, cities c WHERE s.city_id = c.id AND c.state_id = " + @state.id.to_s).paginate(:per_page => per_page, :page => page)
       end
    elsif specialty_id != nil && specialty_id != ''
      find_all_by_specialty_id(specialty_id).paginate(:per_page => per_page, :page => page)
    else
      all.paginate(:per_page => per_page, :page => page)
    end
  end

  def self.get_results(state_id, city_id, specialty_id)
     if state_id != nil && state_id != '--Select a State--'
       #IF CHOOSE STATE, GET CITIES OF THAT STATE
       @state = State.find(state_id)
       @cities = @state.cities

       #IF CITY SELECTED, GET SUPPLIERS FOR THAT CITY AND STATE ONLY
       if city_id != nil && city_id != ''
         @chosen_city = City.find_by_id(city_id)
         #IF SPECIALTY SELECTED, GET SUPPLIERS WITH THAT SPECIALTY ONLY IN THAT CITY AND STATE
         if specialty_id != nil && specialty_id != ''
            @results = "Showing " + Specialty.find_by_id(specialty_id).name + " Suppliers in " + @chosen_city.city_name + ", " + @state.name
         else
           #TEMPORARY SOLUTION UNTIL REFRESH CITY DROPDOWN ON STATE CHANGE
           if @cities.include?(@chosen_city)
             @results = "Showing All Suppliers in " + @chosen_city.city_name + ", " + @state.name
           else
             @results = "Showing All Suppliers in " + @state.name
           end
         end

       #IF NO CITY SELECTED AND SPECIALTY SELECTED, DISPLAY SUPPLIERS WITH THAT SPECIALTY IN THAT STATE
       elsif specialty_id != nil && specialty_id != ''
         @results = "Showing " + Specialty.find_by_id(specialty_id).name + " Suppliers in " + @state.name
       #IF NO CITY OR SPECIALTY SELECTED, RETURN ALL SUPPLIERS IN SELECTED STATE
       else
          @results = "Showing All Suppliers in " + @state.name
       end
    elsif specialty_id != nil && specialty_id != ''
      @results = "Showing " + Specialty.find_by_id(specialty_id).name + " Suppliers in All Cities"
    else
      @results = "Showing All Suppliers in All Cities"
    end
    return @results
  end

  #if states != nil && states != '--Select a State--'
       #IF CHOOSE STATE, GET CITIES OF THAT STATE
  #     @cities = City.find_all_by_state(states)
       #IF CITY SELECTED, GET SUPPLIERS FOR THAT CITY AND STATE ONLY
  #     if city_id != nil && city_id != ''
  #       @chosen_city = City.find_by_id(city_id)
  #       #IF SPECIALTY SELECTED, GET SUPPLIERS WITH THAT SPECIALTY ONLY IN THAT CITY AND STATE
  #       if specialty_id != nil && specialty_id != ''
  #         @suppliers = Supplier.find_by_sql("SELECT * FROM suppliers WHERE city_id = " + @chosen_city.id.to_s + " AND specialty_id = " + specialty_id).paginate(:per_page => @per_page, :page => params[:page])
  #         @results = "Showing " + Specialty.find_by_id(params[:specialty_id]).name + " Suppliers in " + @chosen_city.city_name + ", " + params[:states]
  #       else
  #         #TEMPORARY SOLUTION UNTIL REFRESH CITY DROPDOWN ON STATE CHANGE
  #         if @cities.include?(@chosen_city)
  #           @results = "Showing All Suppliers in " + @chosen_city.city_name + ", " + params[:states]
  #           @suppliers = @chosen_city.suppliers.paginate(:per_page => @per_page, :page => params[:page])
  #         else
  #           @suppliers = Supplier.find_by_sql("SELECT * FROM suppliers s, cities c WHERE s.city_id = c.id AND c.states = '" + params[:states] + "'").paginate(:per_page => @per_page, :page => params[:page])
  #           @results = "Showing All Suppliers in " + params[:states]
  #         end
  #       end
  #
  #     #IF NO CITY SELECTED AND SPECIALTY SELECTED, DISPLAY SUPPLIERS WITH THAT SPECIALTY IN THAT STATE
  #     elsif params[:specialty_id] != nil && params[:specialty_id] != ''
  #       @suppliers = Supplier.find_by_sql("SELECT * FROM suppliers s, cities c WHERE s.city_id = c.id AND c.states = '" + params[:states] + "' AND s.specialty_id = " + params[:specialty_id]).paginate(:per_page => @per_page, :page => params[:page])
  #       @results = "Showing " + Specialty.find_by_id(params[:specialty_id]).name + " Suppliers in " + params[:states]
  #     #IF NO CITY OR SPECIALTY SELECTED, RETURN ALL SUPPLIERS IN SELECTED STATE
  #     else
  #        @suppliers = Supplier.find_by_sql("SELECT * FROM suppliers s, cities c WHERE s.city_id = c.id AND c.states = '" + params[:states] + "'").paginate(:per_page => @per_page, :page => params[:page])
  #        @results = "Showing All Suppliers in " + params[:states]
  #     end
  #  elsif params[:specialty_id] != nil && params[:specialty_id] != ''
  #    @suppliers = Supplier.find_all_by_specialty_id(params[:specialty_id]).paginate(:per_page => @per_page, :page => params[:page])
  #    @results = "Showing " + Specialty.find_by_id(params[:specialty_id]).name + " Suppliers in All Cities"
  #  else
  #    @results = "Showing All Suppliers in All Cities"
  #    @suppliers = Supplier.all.paginate(:per_page => @per_page, :page => params[:page])
  #  end

end

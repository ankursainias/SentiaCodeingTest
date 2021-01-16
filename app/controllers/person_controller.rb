class PersonController < ApplicationController
  include ReadCsv
  include TableComponent

  def index
    respond_to do |format|
      format.html
      format.js do
        @people, total = filter_people_record
        additional_people_keys
        render json: respond(@people, total)
     end
    end
  end

  def import_data
    begin
      raise "Please select a file." unless upload_params[:file].present?
      temp_file = upload_params[:file].tempfile
      if FILE_FORMAT.include?(File.extname(temp_file))

        response = read_csv(temp_file)

        if (missing_col = (REQUIRE_HEADER - response[:header])).present?
          raise "Header columns #{missing_col.join(',')} Mismatch"
        end

        commit_csv_data(response[:content]) if response[:content].present?
      else
        raise 'Only CSV file allowed'
      end
    rescue Exception => e
      flash[:error] = e.message
    end
    redirect_to root_path
  end

  private

  def commit_csv_data(contents)
    contents.each do |content|
      next if content[:affiliations].blank?
      ActiveRecord::Base.transaction do 
        species_id = if content[:species].present?
                    Species.find_or_create_by!(name: content[:species])&.id
                    end
        person = Person.create!(person_params(content).merge(species_id: species_id))
        
        if content[:location].present?
          content[:location].split(',').each do |name|
            Location.create!(name: name, person_id: person.id)
          end
        end

        content[:affiliations].split(',').each do |name|
          Affiliation.create!(name: name, person_id: person.id)
        end
        person.index!
      end
    end
  end

  def filter_people_record
    search = Person.includes(:locations, :affiliations, :speices).search do

      if params.dig(:search, :value).present?
        fulltext params[:search][:value].gsub(' ', '+').squish
      end

      order_by(column_name(:name), direction)
      order_by(:created_at, direction)
      paginate page: page_number, per_page: total_count('Person')

    end
     [search.results, search.total]
  end

  def additional_people_keys
    @people = @people.collect do |person|
      result = person.as_json
      result['locations'] = person.locations.map(&:name)&.join(',')
      result['species'] = person&.speices&.name
      result['affiliations'] =  person.affiliations.map(&:name)&.join(',')
      result
    end
  end

  def person_params(content)
    name_array = content[:name]&.split(' ') || []

    if name_array.count > 1                   
      last_name  = name_array.pop
      first_name = name_array.join(' ')
    else                                      
      first_name = name_array.first           
      last_name  = nil
    end
    { 
      first_name: first_name, last_name:  last_name, vehicle: content[:vehicle],
      gender: content[:gender], weapon: content[:weapon]
    }
  end

  def upload_params
    params.permit(:file, :authenticity_token, :commit)
  end
end

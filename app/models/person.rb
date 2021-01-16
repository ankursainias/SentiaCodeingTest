class Person < ApplicationRecord
  belongs_to :speices, optional: true, foreign_key: :species_id, class_name: 'Species'
  has_many :locations
  has_many :affiliations
  validates :gender, presence: true
  
 before_create :name_titlecase

  searchable( include: { speices: true, affiliations: true, locations: true } ) do
    string :first_name
    string :last_name
    string :weapon
    string :vehicle
    string :gender
    time :created_at

    string :affiliations do
      affiliations&.pluck(:name)&.join(", ")
    end

    string :locations do
      locations&.pluck(:name)&.join(", ")
    end

    string :species do
      speices&.name
    end

    string :species do
      speices&.name
    end

    text :locations_alias do
      locations&.pluck(:name)&.join(", ")
    end

    text :affiliations_alias do
      affiliations&.pluck(:name)&.join(", ")
    end

    text :first_name_alias do
      first_name
    end

    text :last_name_alias do
      last_name
    end

    text :vehicle_alias do
      vehicle
    end

    text :gender_alias do
      gender
    end

  end

  def name_titlecase
    self.first_name = first_name&.titleize
    self.last_name = last_name&.titleize
  end
end

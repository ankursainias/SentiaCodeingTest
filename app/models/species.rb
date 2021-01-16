class Species < ApplicationRecord
  has_many :peoples, foreign_key: :species_id
end

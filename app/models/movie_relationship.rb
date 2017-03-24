class MovieRelationship < ApplicationRecord

  belongs_to :movie
  belongs_to :user
  has_many :movies

end

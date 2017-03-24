class Review < ApplicationRecord
  belongs_to :user
  bolongs_to :movie
end

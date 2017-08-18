class Keyword < ApplicationRecord
  validates :weight, :presence => true
  validates :keyword, :presence => true
  belongs_to :answer

  has_and_belongs_to_many :rsos
end

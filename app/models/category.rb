class Category < ApplicationRecord
    belongs_to :category_group
    has_many :questions
end

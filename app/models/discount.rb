class Discount < ApplicationRecord
  validates_presence_of :type, :discount, :quantity, :active
  belongs_to :user

  enum type: %w[Percentage Flat]
  
end

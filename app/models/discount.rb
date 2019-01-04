class Discount < ApplicationRecord
  validates_presence_of :discount_type, :discount, :quantity, :active
  belongs_to :user

  enum discount_type: %w[Percentage Flat]
end

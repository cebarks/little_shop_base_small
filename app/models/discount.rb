class Discount < ApplicationRecord
  validates_presence_of :discount_type, :discount, :quantity, :active
  belongs_to :user

  enum discount_type: %w[Percentage Flat]


  def self.discount_types_for_merchant(merchant)
    last_discount = merchant.discounts.last

    if last_discount
      [last_discount.discount_type]
    else
      discount_types.keys
    end
  end
end
require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe "Validations" do
    it {should validate_presence_of :discount_type}
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :discount}
    it {should validate_presence_of :active}

    it {should belong_to :user}
  end
end

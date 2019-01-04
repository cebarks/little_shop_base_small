require 'rails_helper'

RSpec.describe Discount, type: :model do
  describe "Validations" do
    it {should validate_presence_of :discount_type}
    it {should validate_presence_of :quantity}
    it {should validate_presence_of :discount}
    it {should validate_presence_of :active}

    it {should belong_to :user}
  end

  describe "Instance Methods" do
    it "#discount_str" do
      merchant = create(:merchant)
      discount = Discount.create!(discount_type: 'Flat', discount: 1, quantity: 1, user: merchant)
      expect(discount.discount_str).to eq("$1.00")
    end
  end

  describe "Class Methods" do
    describe ".discount_types_for_merchant" do
      before(:each) do
        @merchant = create(:merchant)
      end

      it "no prior discounts" do
        expect(Discount.discount_types_for_merchant(@merchant)).to eq(%w[Percentage Flat])
      end

      it "prior 'Flat' discount" do
        Discount.create!(discount_type: 'Flat', discount: 1, quantity: 1, user: @merchant)
        expect(Discount.discount_types_for_merchant(@merchant)).to eq(%w[Flat])
      end

      it "prior 'Percentage' discount" do
        Discount.create!(discount_type: 'Percentage', discount: 1, quantity: 1, user: @merchant)
        expect(Discount.discount_types_for_merchant(@merchant)).to eq(%w[Percentage])
      end
    end
  end
end

require 'rails_helper'

RSpec.describe "As a merchant" do
  before(:each) do
    @merchant = create(:merchant)
    @item = create(:item, user: @merchant)
    @discount_1 = Discount.create!(discount_type: 'Flat', quantity: 10, discount: 10, user: @merchant)

    post_login(@merchant)
  end

  describe "When I visit my Dashboard" do
    before(:each) do
      visit dashboard_path
    end

    it "I see a 'view' link to view a discount for my items" do
      expect(page).to have_link('View', href: dashboard_discount_path(@discount_1))
    end

    describe "When I click on the 'View' button" do
      before(:each) do
        within "#discount-0" do
          click_on 'View'
        end
      end

      it "I see all the information of that discount" do
        within "#discount-view" do
          expect(page).to have_content("ID: #{@discount_1.id}")
          expect(page).to have_content("Quantity Required: #{@discount_1.quantity}")
          expect(page).to have_content("Discount Type: #{@discount_1.discount_type}")
          expect(page).to have_content("Discount Amount: #{@discount_1.discount_str}")
        end
      end
    end
  end
end

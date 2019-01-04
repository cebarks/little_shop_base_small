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

    it "I see a link to 'delete' a discount next to each discount" do
      within "#discounts-table #discount-0 .discount-actions" do
        expect(page).to have_link('Delete', href: dashboard_discount_path(@discount_1))
      end
    end

    describe "When I click on the 'Delete' link" do
      before(:each) do
        within "#discount-0" do
          click_on 'Delete'
        end
      end

      it "I am taken to my dashboard" do
        expect(current_path).to eq(dashboard_path)
      end

      it "I see that the discount has been deleted" do
        expect(page).to_not have_css('#discount-0')
        expect(page).to_not have_content(@discount_1.discount_type)
        expect(page).to_not have_content(@discount_1.quantity)
        expect(page).to_not have_content(@discount_1.discount)
      end
    end
  end
end

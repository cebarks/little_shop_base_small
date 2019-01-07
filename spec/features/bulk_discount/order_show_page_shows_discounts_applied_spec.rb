require 'rails_helper'

RSpec.describe "As a user" do
  before(:each) do
    @user = create(:user)
    post_login(@user)
    @item = create(:item, inventory: 10)
    @merchant = @item.user
  end

  describe "When I checkout with a discount applied to my cart" do
    before(:each) do
      page.driver.post(cart_add_item_path(@item))

      2.times do
        page.driver.post(cart_add_more_item_path(@item))
      end

      visit cart_path
    end

    describe "A flat discount" do
      it "reflects that on the order show page" do
        Discount.create!(user: @merchant, quantity: 2, discount: 10, discount_type: 'Flat')
        click_on 'Check out'
        visit profile_order_path(Order.last)
        expect(page).to have_content("Total Discount Applied: $10.00")
      end
    end

    describe "A percentage discount" do
      it "reflects that on the order show page" do
        Discount.create!(user: @merchant, quantity: 2, discount: 10, discount_type: 'Percentage')
        click_on 'Check out'
        visit profile_order_path(Order.last)
        expect(page).to have_content("Total Discount Applied: 10%")
      end
    end
  end
end

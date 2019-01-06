require 'rails_helper'

RSpec.describe "As a user" do
  before(:each) do
    @user = create(:user)
    @merchant = create(:merchant)
    @item = create(:item, inventory: 10, price: 3, user: @merchant)
    @discount = Discount.create!(user: @merchant, discount_type: 'Flat', discount: 5, quantity: 3)

    post_login(@user)
  end

  describe "When I add enough of one item to my cart" do
    before(:each) do
      page.driver.post(cart_add_item_path(@item))

      2.times do
        page.driver.post(cart_add_more_item_path(@item))
      end

      visit cart_path
    end

    it "I see a new discount applied to that item" do
      within "#item-#{@item.id}" do
        expect(page).to have_content("Subtotal: $4.00")
        expect(page).to have_content("Bulk Discount applied to this item.")
      end
    end
  end

  describe "When I don't add enough of one item to my cart" do
    before(:each) do
      page.driver.post(cart_add_item_path(@item))

      visit cart_path
    end

    it "I don't see a discount applied to that item" do
      within "#item-#{@item.id}" do
        expect(page).to_not have_content("Subtotal: $4.00")
        expect(page).to_not have_content("Bulk Discount applied to this item.")
      end
    end
  end
end

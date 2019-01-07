require 'rails_helper'

RSpec.describe "As a user" do
  before(:each) do
    @user = create(:user)
    @item = create(:item, inventory: 10, price: 3)
    @merchant = @item.user
    @discount = Discount.create!(user: @merchant, discount_type: 'Flat', discount: 5, quantity: 3)

    post_login(@user)
  end

  describe "When I add enough of one item to my cart" do
    before(:each) do
      page.driver.post(cart_add_item_path(@item))

      2.times do
        page.driver.post(cart_add_more_item_path(@item))
      end
    end

    it "I see a new discount applied to that item" do
      visit cart_path

      within "#item-#{@item.id}" do
        expect(page).to have_content("Subtotal: $4.00")
        expect(page).to have_content("Bulk Discount applied to this item.")
      end
    end

    describe "If there's two valid discounts active" do
      it "only the highest discount is applied" do
        discount_2 = Discount.create!(user: @merchant, discount_type: 'Flat', discount: 6, quantity: 3)
        visit cart_path
        
        within "#item-#{@item.id}" do
          expect(page).to have_content("Subtotal: $3.00")
          expect(page).to have_content("Bulk Discount applied to this item.")
        end
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

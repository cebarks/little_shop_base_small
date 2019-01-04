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

    it "I see a link to edit a discount next to each discount" do
      within "#discounts-table #discount-0 .discount-actions" do
        expect(page).to have_link('Edit', href: edit_dashboard_discount_path(@discount_1))
      end
    end

    describe "When I click on the 'Edit' link" do
      before(:each) do
        within "#discount-0" do
          click_on 'Edit'
        end
      end

      it "I am taken to the edit page for that discount" do
        expect(current_path).to eq(edit_dashboard_discount_path(@discount_1))
      end

      it "I see a form to edit the different attributes " do
        expect(page).to have_css('#discount-edit-form')
      end

      describe "When I edit the information in the form and click 'Update Discount'" do
        before(:each) do
          @new_discount_type = 'Percentage'
          select @new_discount_type, from: :discount_discount_type
          click_on 'Update Discount'
        end

        it "I am taken back to my dashboard ('/dashboard')" do
          expect(current_path).to eq(dashboard_path)
        end

        it "I see the changes I made reflected in the discounts table" do
          within "#discounts-table #discount-0 .discount-type" do
            expect(page).to have_content('Percentage')
          end
        end
      end
    end
  end
end

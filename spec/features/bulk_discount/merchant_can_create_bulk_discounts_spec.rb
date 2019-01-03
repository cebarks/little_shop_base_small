require 'rails_helper'

RSpec.describe "As a merchant" do
  before(:each) do
    @merchant = create(:merchant)
    @item = create(:item, user: @merchant)
    post_login(@merchant)
  end

  describe "When I visit my Dashboard" do
    before(:each) do
      visit dashboard_path
    end

    it "I see a 'New Bulk Discount' button to create a new coupon for my items" do
      expect(page).to have_button('New Bulk Discount')
    end
    describe "When I click on the 'New Bulk Discount' button" do
      before(:each) do
        click_on 'New Bulk Discount'
      end

      it "I see a form to create a new discount" do
        expect(page).to have_css '#discount-form'
      end

      describe "When I fill out the form with valid information and submit it" do
        before(:each) do
          @quantity = 15
          @discount = 5
          @type = 'Flat'

          within "#discount-form" do
            fill_in :discount_quantity, with: @quantity
            fill_in :discount_discount, with: @discount
            select @type, from: 'type'
            click_on 'Create Discount'
          end
        end

        it "I see a flash message telling me my discount was created successfully" do
          within '#flashes' do
            expect(page).to have_content('Your discount was created successfully.')
          end
        end

        it "I know see the discount listed on my dashboard" do
          expect(current_path).to eq(dashboard_path)
          within "#discounts-table" do
            within "#discount-0" do
              within ".discount-quantity" do
                expect(page).to have_content(@quantity)
              end

              within ".discount-type" do
                expect(page).to have_content(@type)
              end

              within ".discount-active" do
                expect(page).to have_content('yes')
              end

              within ".discount-discount" do
                expect(page).to have_content(@discount)
              end
            end
          end
        end
      end

      # describe "When I fill out the form with invalid information" do
      #
      # end
    end
  end
end

# Merchants can implement bulk discount rates on their inventory. When a user sets their cart quantity to a certain level, those discounts get applied. For example, a merchant might set bulk discounts this way:
#
# 1 to 10 of a single item, no discount
# 10 to 20 of a single item, 5% discount on that item's price
# 20+ of a single item, 10% discount on that item's price
# You'll need to build CRUD pages to manage this.
#
# Merchants must be able to include mutiple bulk discounts, but only one type.
# For example, a merchant cannot have bulk discounts that are both dollar-based
# ($10 off $30 or more) AND a percentage-off (15% off 20 items or more) at the same time.

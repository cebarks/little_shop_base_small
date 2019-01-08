require 'rails_helper'

RSpec.describe "As a merchant" do
  before(:each) do
    @item = create(:item, inventory: 5)
    @merchant = @item.user

    post_login(@merchant)
  end
  describe "When I visit my dashboard ('/dashboard')" do
    before(:each) do
      order = create(:completed_order)
      create(:fulfilled_order_item, order: order, item: @item, quantity: 5)

      visit dashboard_path
    end

    it "I see a pie chart representing my quantity sold statistic" do
      expect(page).to have_css('#chart-1')
    end
  end
end

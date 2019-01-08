require 'rails_helper'

RSpec.describe "As a merchant" do
  before(:each) do
    @item = create(:item, inventory: 5)
    @merchant = @item.user

    post_login(@merchant)
  end

  describe "When I visit my dashboard ('/dashboard')" do
    before(:each) do
      visit dashboard_path
    end

    it "I see a chart representing my sales by month" do
        expect(page).to have_css('#monthly-sales-chart')
    end
  end
end

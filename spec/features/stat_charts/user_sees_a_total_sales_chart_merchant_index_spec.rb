require 'rails_helper'

RSpec.describe "As a visitor" do
  describe "When I visit the merchant index page ('/merchants')" do
    before(:each) do
      visit merchants_path
    end

    it "I see a pie chart of total site sales broken down by merchants with fulfilled items" do
      expect(page).to have_css("#total-sales-chart")
    end
  end
end

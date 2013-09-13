require 'spec_helper'

describe "Home" do
  describe "GET /home_chooses" do
    it "should have the content 'Sample App'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #get home_chooses_path
      #response.status.should be(200)
	  visit '/choose'
	  expect(page).to have_content('Sample App')
    end
  end

  describe "GET /home_help" do
    it "should have the content 'Help'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #get home_chooses_path
      #response.status.should be(200)
	  visit '/help'
	  expect(page).to have_content('Help')
    end
  end

end

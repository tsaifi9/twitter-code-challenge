require "rails_helper"

feature "getting user tweets", js: true do
  let(:user) { create(:user) }

  before do
    login_as(user, :scope => :user)
  end

  it "shows a list of tweets for a given user" do
    visit root_path
    stub_twitter_user_search

    fill_in "user", :with => "user-exists"
    click_button "Search"

    within page.find('#tweets') do
      expect(page).to have_text("first")
      expect(page).to have_text("10/31/2002 02:02AM")

      expect(page).to have_text("second")
      expect(page).to have_text("01/02/2005 01:04PM")
    end

    stub_twitter_user_search(user: "user-dne", results: [])
    fill_in "user", :with => "user-dne"
    click_button "Search"

    expect(page).to_not have_text("first")
    expect(page.find('#tweets').text).to eq("")
  end
end
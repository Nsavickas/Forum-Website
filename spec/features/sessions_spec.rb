require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  self.use_transactional_fixtures = false
  
  let(:admin_user) {FactoryGirl.create(:user, admin: true)}
  let(:normal_user) {FactoryGirl.create(:user, email: "example1@railstutorial.org", 
    password: "foobar3000")}
  
  scenario "login with correct details" do
    
    visit "/"

    click_link "Log in"
    expect(page).to have_css("h1", text: "Log in")
    expect(page).to have_title("Log in")
    expect(current_path).to eq(login_path)

    login admin_user.email, admin_user.password

    expect(current_path).to eq "/users/#{admin_user.id}"
    expect(page).to have_css("div", text: "Recent Activity:")
    expect(page).to have_title("#{admin_user.name}")
    expect(page).to have_content "Log in successful"

    click_link "Account"
    click_link "Log out"

    expect(current_path).to eq "/"
    expect(page).to have_content "Log out successful"
    expect(page).not_to have_content "someone@example.tld"

  end

  private

  def login(email, password)
    fill_in "Email", :with => email
    fill_in "Password", :with => password
    click_button "Log in"
  end

  
end

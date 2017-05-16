require 'rails_helper'

RSpec.feature "Avatars", type: :feature do
  let(:user){FactoryGirl.create(:user)}
  let(:user_with_avatar){FactoryGirl.create(:user_with_avatar)}
  
  context "correct user" do
    it "can create new avatar" do
      new_user = user
      page.set_rack_session(user_id: new_user.id)
      visit user_path(new_user)
      
      expect(page).to have_title('Example User')
      find(:xpath, "//a/img[@alt='New DP']/..").click
      
      expect(current_path).to eq(new_user_avatar_path(new_user))
      attach_file('Display Picture', "spec/support/fixtures/zombs.jpg")
      click_button 'Create Avatar'
      new_avatar = Avatar.last
      
      expect(current_path).to eq(user_path(new_avatar.user))
      expect(page).to have_content('Avatar was successfully created')
      expect(page).to have_css('a', 'zombs.jpg')
    end
    
    it "can change avatar" do
      new_user = user_with_avatar
      page.set_rack_session(user_id: new_user.id)
      visit user_path(new_user)
      
      expect(page).to have_title('Example User')
      find(:xpath, "//a/img[@alt='Edit DP']/..").click
      
      expect(current_path).to eq(edit_avatar_path(new_user.avatar))
      attach_file('Display Picture', "spec/support/fixtures/zombs.jpg")
      click_button 'Save changes'
      
      expect(current_path).to eq(user_path(new_user))
      expect(page).to have_content('Avatar updated')
      expect(page).to have_xpath("//a/img[@alt='Edit DP']/..")
    end
  end
  
  context "other user" do
    before :each do 
      page.set_rack_session(user_id: user.id)
    end
    
    it "cannot change avatar" do
      visit edit_avatar_path(user_with_avatar.avatar)
      expect(current_path).to eq(root_path)
    end
    
    it "can view avatar via :show" do
      visit user_path(user_with_avatar)
      expect(page).to have_xpath("//a/img[@alt='Show DP']/..")
    end
  end
end

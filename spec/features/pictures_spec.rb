require 'rails_helper'

RSpec.feature "Pictures", type: :feature do 
  let(:user){FactoryGirl.create(:user)}
  let(:admin_user){FactoryGirl.create(:user, admin: true)}
  let(:user_pictures){FactoryGirl.create(:user_with_pictures)}
  
  feature "non-admin user" do
    before :each do 
      page.set_rack_session(user_id: user.id)
    end
    
    it "can upload pictures and delete own pictures" do
      visit edit_user_path(user)
      
      attach_file('images[]', "spec/support/fixtures/zombs.jpg")
      click_button "Save changes"
      
      new_picture = Picture.last
      
      expect(current_path).to eq(user_path(user.id))
      expect(page).to have_content('Profile updated')
      click_link "Pictures"
      
      expect(page).to have_css("h1", "Example User's Photos")
      expect(page).to have_xpath("//a/img[@alt='Image-#{new_picture.id}']/..")
      click_link 'Delete'
      
      expect(current_path).to eq(user_photos_path(user.id))
      expect(page).to have_content('Picture removed')
      expect(page).not_to have_xpath("//a/img[@alt='Image-#{new_picture.id}']/..")
    end  
  end
  
  feature "admin user" do
    before :each do 
      page.set_rack_session(user_id: admin_user.id)
    end
    
    it "can delete other user's pictures" do
      visit user_photos_path(user_pictures.id)
      
      expect(page).to have_xpath("//a/img[@alt='Image-#{user_pictures.id}']/..")
      click_link 'Delete'
      
      expect(current_path).to eq(user_photos_path(user.id))
      expect(page).to have_content('Picture removed')
      #expect(page).not_to have_xpath("//a/img[@alt='Image-#{new_picture.id}']/..")
    end
    
    it "can mark default pictures for store" do
      new_user = user_pictures
      visit pictures_path
      
      expect(page).to have_xpath("//a/img[@alt='Image-#{user_pictures.id}']/..")
      expect(new_user.pictures.last.default_image).to eq(false)
      click_link 'Edit'
      
      expect(page).to have_title('h1', 'Edit Picture')
      check 'Set as default image?'
      click_button 'Update Picture'
      
      expect(current_path).to eq(pictures_url)
      expect(new_user.pictures.last.default_image).to eq(true)
    end
  end
end

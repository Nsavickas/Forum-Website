require 'rails_helper'

RSpec.feature "Forums", type: :feature do
   
  let(:user){FactoryGirl.create(:user)}
  let(:admin_user){FactoryGirl.create(:user, admin: true)}
  let(:forum) {FactoryGirl.create(:forum_with_subforums)}
  
  feature "guest interacting with forum" do    
    it "should redirect to login page when accessing :create" do 
      visit new_forum_path
      expect(current_path).to eq(login_path)
    end  
    
    it "should redirect to login page when accessing :edit" do 
      new_forum = forum
      visit "/forums/#{new_forum.id}/edit"
      expect(current_path).to eq(login_path)
    end
    
    it "should be able to view associated subforums" do
      new_forum = forum
      visit "forums/#{new_forum.id}/subforums"
      
      expect(page).to have_css('a', 'General Discussion')
      expect(page).to have_title("#{new_forum.forumname}'s Subforums")
    end
  end
  
  feature "non-admin user interacting with forum" do
    before :each do 
      page.set_rack_session(user_id: user.id)
    end
     
    it "should redirect to root page when accessing :create" do 
      visit "/forums/new"
      expect(current_path).to eq(root_path)
    end  
    
    it "should redirect to root page when accessing :edit" do 
      forum
      visit "/forums/#{forum.id}/edit"
      expect(current_path).to eq(root_path)
    end
    
    it "should be able to view associated subforums" do
      new_forum = forum
      visit "forums/#{new_forum.id}/subforums"
      
      expect(page).to have_css('a', 'General Discussion')
      expect(page).to have_title("#{new_forum.forumname}'s Subforums")
    end
  end
  
  feature "admin user interacting with forum" do 
    before :each do 
      page.set_rack_session(user_id: admin_user.id)
    end
    
    it "can create forum if valid" do 
      visit "/forums/new"
    
      fill_in "Forum Name", :with => "Planetside1"
      click_button "Submit"
    
      new_forum = Forum.last
      
      expect(page).to have_title("Planetside1")
      expect(page).to have_content("Forum was successfully created.")
      expect(current_path).to eq(forum_path(new_forum.id))
    end
    
    it "can update forum if valid" do 
      new_forum = forum
      visit "/forums/#{new_forum.id}/edit"
      
      expect(page).to have_css("h1", "Update the Forum")
      
      fill_in "New Forum Name", :with => "NaziZombies"
      click_button "Save changes"
      
      expect(current_path).to eq(forum_path(new_forum))
      expect(page).to have_content("Forum updated")
      expect(page).to have_css("h1", "NaziZombies")
    end
    
    it "can delete forum" do
      new_forum = forum
      visit "/forums"
      click_link "Destroy"
      
      expect(current_path).to eq(forums_path)
      expect(page).to have_content("Forum deleted")
      expect(page).not_to have_css("a", text: "Planetside1")
    end
    
    it "should be able to view associated subforums" do
      new_forum = forum
      visit "forums/#{new_forum.id}/subforums"
      
      expect(page).to have_css('a', 'General Discussion')
      expect(page).to have_title("#{new_forum.forumname}'s Subforums")
    end
  end
   
end

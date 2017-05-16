require 'rails_helper'

RSpec.feature "Subforums", type: :feature do
  let(:user){FactoryGirl.create(:user)}
  let(:admin_user){FactoryGirl.create(:user, admin: true)}
  let(:subforum) {FactoryGirl.create(:subforum_with_posts)}
  let(:forum) {FactoryGirl.create(:forum)}
    
  feature "guest interacting with subforum" do    
    it "should redirect to login page when accessing :create" do 
      visit new_forum_subforum_path(forum)
      expect(current_path).to eq(login_path)
    end  
    
    it "should redirect to login page when accessing :edit" do 
      new_subforum = subforum
      visit "/subforums/#{new_subforum.id}/edit"
      expect(current_path).to eq(login_path)
    end
    
    it "should be able to view associated posts" do
      new_subforum = subforum
      visit "subforums/#{new_subforum.id}/posts"
      
      expect(page).to have_css('a', 'Sheep')
      expect(page).to have_title("#{new_subforum.subforumname}'s Posts")
    end
  end
  
  feature "non-admin user interacting with subforum" do
    before :each do 
      page.set_rack_session(user_id: user.id)
    end
     
    it "should redirect to root page when accessing :create" do 
      visit new_forum_subforum_path(forum)
      expect(current_path).to eq(root_path)
    end  
    
    it "should redirect to root page when accessing :edit" do 
      new_subforum = subforum
      visit "/subforums/#{new_subforum.id}/edit"
      expect(current_path).to eq(root_path)
    end
    
    it "should be able to view associated posts" do
      new_subforum = subforum
      visit "subforums/#{new_subforum.id}/posts"
      
      expect(page).to have_css('a', 'Sheep')
      expect(page).to have_title("#{new_subforum.subforumname}'s Posts")
    end
  end
  
  feature "admin user interacting with subforum" do 
    before :each do 
      page.set_rack_session(user_id: admin_user.id)
    end
    
    it "can create subforum if valid" do 
      parent_forum = forum
      visit new_forum_subforum_path(parent_forum)
    
      fill_in 'Subforum Name', :with => "Other"
      click_button "Submit"
      
      new_subforum = Subforum.last
    
      expect(page).to have_title("Other")
      expect(new_subforum.forum).to eq(parent_forum)
      expect(page).to have_content("Subforum was successfully created.")
      expect(current_path).to eq(subforum_path(new_subforum.id))
    end
    
    it "can update subforum if valid" do 
      new_subforum = subforum
      visit "/subforums/#{new_subforum.id}/edit"
      
      expect(page).to have_css("h1", "Update the Subforum")
      
      fill_in "New Subforum Name", :with => "Announcements"
      click_button "Save changes"
      
      expect(current_path).to eq(subforum_path(new_subforum))
      expect(page).to have_content("Subforum updated")
      expect(page).to have_css("h1", "Announcements")
    end
    
    it "can delete subforum" do
      parent_forum = forum
      new_subforum = FactoryGirl.create(:subforum_with_posts, 
        :subforumname => "General Discussion", :forum => parent_forum)
      visit "/forums/#{parent_forum.id}/subforums"
      
      expect(page).to have_title("#{parent_forum.forumname}'s Subforums")
      expect(page).to have_css("a", text: "General Discussion")
      
      click_link "Destroy"
      
      expect(current_path).to eq(forum_subforums_path(parent_forum))
      expect(page).to have_content("Subforum deleted")
      expect(page).not_to have_css("a", text: "General Discussion")
    end
    
    it "should be able to view associated posts" do
      new_subforum = subforum
      visit "subforums/#{new_subforum.id}/posts"
      
      expect(page).to have_css('a', 'Sheep')
      expect(page).to have_title("#{new_subforum.subforumname}'s Posts")
    end
  end
end



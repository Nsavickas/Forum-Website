require 'rails_helper'

RSpec.feature "Posts", type: :feature do
  let(:user){FactoryGirl.create(:user)}
  let(:admin_user){FactoryGirl.create(:user, admin: true)}
  let(:comment_post){FactoryGirl.create(:post_with_comments)}
  let(:picture_post){FactoryGirl.create(:post_with_pictures)}
  let(:post){FactoryGirl.create(:post)}
  let(:subforum){FactoryGirl.create(:subforum)}
  
  feature "guest interacting with post" do    
    it "should redirect to login page when accessing :create" do 
      visit new_subforum_post_path(subforum)
      expect(current_path).to eq(login_path)
    end  
    
    it "should redirect to login page when accessing :edit" do 
      new_post = post
      visit "/posts/#{new_post.id}/edit"
      expect(current_path).to eq(login_path)
    end
    
    context "viewing :show" do
      it "should have content" do
        new_post = post
        visit "posts/#{new_post.id}"
        
        expect(page).to have_css("h1", "Sheep")
        expect(page).to have_title("Sheep")
      end
      
      it "should have pictures" do
        new_post = picture_post
        visit "posts/#{new_post.id}"
        
        expect(page).to have_title("Sheep")
        expect(page).to have_css(".post-pictures img")
      end
      
      it "should have comments" do
        new_post = comment_post
        visit "posts/#{new_post.id}"
        
        expect(page).to have_title("Sheep")
        expect(page).to have_css("a", "Example User")
        expect(page).to have_css("p", "Sheep are truly negus")
      end
    end   
  end
  
  feature "non-admin user interacting with post" do
    before :each do 
      page.set_rack_session(user_id: user.id)
    end
     
    it "can create new post" do 
      parent_subforum = subforum
      current_user = user
      
      visit new_subforum_post_path(parent_subforum.id)
      
      fill_in 'Post Name', :with => "Sheep Forever"
      fill_in 'Content', :with => "All sheep are exulted"
      attach_file('images[]', "spec/support/fixtures/zombs.jpg")
      click_button "Submit Post"
      
      new_post = Post.last
      
      expect(page).to have_content("Post was successfully created.")
      expect(page).to have_css('h2', 'Authored by: Example User')
      expect(current_path).to eq(post_path(new_post.id))
      expect(page).to have_css('img')
      expect(page).to have_title('Sheep Forever')
    end  
    
    it "cannot create posts in Announcements subforum" do
      announcement_subforum = FactoryGirl.create(:subforum, subforumname: "Announcements")
      
      visit new_subforum_post_path(announcement_subforum.id)
       
      expect(current_path).to eq(root_path)
      expect(page).to have_content("You don't have the necessary privileges to post in that subforum") 
    end
    
    it "can view post with associated comments" do
      new_post = comment_post
      visit post_path(new_post.id)
      
      expect(page).to have_title('Sheep')
      expect(page).to have_css('div', 'Long live the sheep')
    end
    
    context "cannot sticky posts" do      
      it "using toggle_sticky button" do
        parent_subforum = subforum
        new_post = FactoryGirl.create(:post, subforum: parent_subforum, user: user)
        visit subforum_posts_path(parent_subforum.id)
        
        expect(page).to have_title("#{parent_subforum.subforumname}'s Posts")
        expect(page).not_to have_css('input', 'Toggle Sticky')
      end
      
      it "using sticky_checkbox" do
        parent_subforum = subforum
        new_post = FactoryGirl.create(:post, subforum: parent_subforum, user: user)
        visit edit_post_path(new_post.id)
          
        expect(page).to have_title("Edit #{new_post.postname}")
        expect(page).to have_no_field('sticky')      
      end
    end
    
    context "post created by user", js: true do 
      it "can edit post" do 
        new_post = FactoryGirl.create(:post, user: user)
        visit edit_post_path(new_post.id)
        
        expect(page).to have_title("Edit #{new_post.postname}")
        
        fill_in 'Post Name', :with => "Goat Lyfe" 
        click_button 'Save changes'
        
        expect(current_path).to eq(post_path(new_post.id))
        expect(page).to have_content("Post updated")
        expect(page).to have_title("Goat Lyfe")
      end
      
      it "can destroy post" do
        new_post = FactoryGirl.create(:post, user: user)
        visit post_path(new_post.id)
        
        expect(page).to have_title('Sheep')
        expect(page).to have_css('input', 'Destroy')
        
        click_link "Destroy"
        page.driver.browser.switch_to.alert.accept     
        
        expect(current_path).to eq(subforum_posts_path(new_post.subforum))
        expect(page).to have_content('Post deleted')
        expect(page).to have_no_link('Sheep')
      end
    end
    
    context "posts created by different user", js: true do
      it "cannot edit post" do
        parent_subforum = FactoryGirl.create(:subforum)
        new_post = FactoryGirl.create(:post, user: admin_user, subforum: parent_subforum)
        
        visit edit_post_path(new_post.id)
        expect(current_path).to eq(root_path)
        
        visit subforum_posts_path(parent_subforum.id)
        expect(page).to have_title("#{parent_subforum.subforumname}'s Posts") 
        within '.misc' do
          expect(page).not_to have_css('a', 'Edit')
        end 
      end
      
      it "cannot delete post" do
        parent_subforum = FactoryGirl.create(:subforum)
        new_post = FactoryGirl.create(:post, user: admin_user, subforum: parent_subforum)
        visit post_path(new_post.id)
        
        expect(page).to have_title('Sheep')
        within '.edit-destroy-comment' do
          expect(page).not_to have_css('a', 'Destroy')
        end
        
        visit subforum_posts_path(parent_subforum.id)
        
        expect(page).to have_title("#{parent_subforum.subforumname}'s Posts")
        within '.misc' do
          expect(page).not_to have_css('a', 'Destroy')
        end        
      end
    end
  end
  
  feature "admin user interacting with post", js: true do 
    before :each do 
      page.set_rack_session(user_id: admin_user.id)
    end
    
    it "can delete any post" do
      parent_subforum = subforum
      new_post = FactoryGirl.create(:post, user: user, subforum: parent_subforum)
      
      visit subforum_posts_path(parent_subforum.id)
      expect(page).to have_title('General Discussion')
      
      within '.misc' do
        click_link "Destroy"
      end
      page.driver.browser.switch_to.alert.accept
      
      expect(current_path).to eq(subforum_posts_path(parent_subforum.id))
      expect(page).not_to have_css('a', 'Sheep')
    end
    
    context "sticky posts" do
      it "using toggle_sticky button" do
        parent_subforum = subforum
        new_post = FactoryGirl.create(:post, subforum: parent_subforum, user: user)
        visit subforum_posts_path(parent_subforum.id)
        
        expect(page).to have_css('div', 'Unstickied')
        click_button('Toggle Sticky')
        
        expect(page).to have_css('div', 'Stickied')
      end
      
      it "using sticky_checkbox" do
        parent_subforum = subforum
        new_post = FactoryGirl.create(:post, subforum: parent_subforum, user: user)
        visit subforum_posts_path(parent_subforum.id)
        
        expect(page).to have_css('div', 'Unstickied')
        click_link('Edit')
        
        expect(page).to have_title("Edit Your Post")
        expect(page).to have_css('input', 'sticky')
        
        check 'Sticky this post?'
        click_button('Save changes')
        
        expect(current_path).to eq(post_path(new_post.id))
        expect(page).to have_css('div', 'Stickied')  
      end
    end
  end
end

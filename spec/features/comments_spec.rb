require 'rails_helper'

RSpec.feature "Comments", type: :feature do
  let(:post){FactoryGirl.create(:post)}
  let(:user){FactoryGirl.create(:user)}
  let(:user_with_avatar){FactoryGirl.create(:user_with_avatar)}
  let(:admin_user){FactoryGirl.create(:user, admin: true)}
  let(:comment){FactoryGirl.create(:comment, post: post)}
  
  feature "guest interacting with comments" do
    context "cannot create comment" do
      it "via link" do
        visit post_path(post)
        within '.post-body' do
          expect(page).not_to have_css('a', 'Comment')
        end
      end
      
      it "via url" do
        visit new_post_comment_path(post)
        expect(current_path).to eq(login_path)
      end
    end
  end
  
  feature "non-admin user interacting with comments" do
    before :each do 
      new_user = user
      page.set_rack_session(user_id: new_user.id)
    end
    
    context "creating comment" do
      it "can create comment" do
        visit post_path(post)
        expect(page).to have_css('h1', 'Sheep')
        
        click_link('Comment')
        fill_in 'Content', :with => 'This is the first comment'
        click_button('Submit Comment')
        new_comment = Comment.last
        
        expect(current_path).to eq(post_path(new_comment.post))
        expect(page).to have_css('div', 'This is the first comment')
        expect(page).to have_content('Comment was successfully created')
      end
      
      it "should have user info and avatar" do
        new_comment = FactoryGirl.create(:comment, user: user_with_avatar)
        visit post_path(new_comment.post)
        
        within '.commenter' do
          expect(page).to have_css('img')
        end
        
        expect(page).to have_css('a', 'Example User')
      end
    end
    
    context "own comment", js: true do
      it "can be edited" do
        #new_user = user
        parent_post = post
        new_comment = FactoryGirl.create(:comment, user: new_user, post: parent_post)
        page.set_rack_session(user_id: new_user.id)  
        
        visit post_path(parent_post)
        expect(page).to have_title('Sheep')
        
        within ".comment" do
          click_link "Edit"
        end
        
        expect(current_path).to eq(edit_comment_path(new_comment.id))
        fill_in 'Content', :with => 'This is the second comment'
        click_button 'Save changes'
        
        expect(current_path).to eq(post_path(parent_post))
        expect(page).to have_css('div', 'This is the second comment')
        expect(page).to have_content('Comment updated')
      end
      
      it "can be deleted" do
        new_user = user
        page.set_rack_session(user_id: new_user.id)  
        parent_post = post
        new_comment = FactoryGirl.create(:comment, user: new_user, post: parent_post)
        
        visit post_path(parent_post)
        expect(page).to have_title('Sheep')
        
        within ".comment" do
          click_link "Delete"
        end
        page.driver.browser.switch_to.alert.accept   
        
        expect(current_path).to eq(post_path(parent_post))
        expect(page).to have_content('Comment deleted')
        expect(page).not_to have_selector('.comment')
      end
    end
    
    context "other user's comments" do
      before :each do
        new_user = user
        page.set_rack_session(user_id: new_user.id)   
      end
      
      it "cannot be edited" do
        other_user = user
        parent_post = post
        new_comment = FactoryGirl.create(:comment, user: other_user, post: parent_post)
        
        visit post_path(parent_post)
        within '.comment' do
          expect(page).not_to have_css('a', 'Edit')
        end
        
        visit edit_comment_path(new_comment)
        expect(current_path).to eq(root_url)
      end
      
      it "cannot be deleted" do
        other_user = user
        parent_post = post
        new_comment = FactoryGirl.create(:comment, user: other_user, post: parent_post)
        
        visit post_path(parent_post)
        within '.comment' do
          expect(page).not_to have_css('a', 'Delete')
        end
      end
    end
  end
  
  feature "admin user interacting with comments", js: true do
    before :each do 
      page.set_rack_session(user_id: admin_user.id)
    end
    
    it "can delete any comment" do
      other_user = user
      parent_post = post
      new_comment = FactoryGirl.create(:comment, user: other_user, post: parent_post)
      
      visit post_path(parent_post)
      expect(page).to have_title('Sheep')
      
      within ".comment" do
        click_link "Delete"
      end
      page.driver.browser.switch_to.alert.accept   
      
      expect(current_path).to eq(post_path(parent_post))
      expect(page).to have_content('Comment deleted')
      expect(page).not_to have_selector('.comment')
    end
  end
end

require 'rails_helper'

RSpec.feature "Likes", type: :feature do
  #self.use_transactional_fixtures = false
  
  let(:user){FactoryGirl.create(:user)}
  let(:post_with_comments) {FactoryGirl.create(:post_with_comments, user: user)}
  
  feature "logged_in user", js: true do
    before :each do 
      page.set_rack_session(user_id: user.id)
    end
    
    it "can like/unlike post" do
      visit "/posts/#{post_with_comments.id}"
    
      within "#post-like-button-#{post_with_comments.id}" do
        click_button "Like"
      end
      
      expect(current_path).to eq(post_path(post_with_comments))
      expect(page).to have_selector(:link_or_button, 'Unlike')
      #expect(get_post_score(post_with_comments.id)).to eq(1)
      
      #find(:css, ".likes-checkbox").set(true)
      check "likes-checkbox"
      expect(page).to have_css("div", text: "Liked by: Example User")
      expect(page).to have_css("div", text: "Score: 1")
      
      within "#post-like-button-#{post_with_comments.id}" do
        click_button "Unlike"
      end
      
      expect(page).to have_selector(:link_or_button, 'Like')
      expect(page).to have_css("div", text: "Liked by:")
      expect(page).to have_css("div", text: "Score: 0")
          
    end
    
    it "can like/unlike comment" do
      
    end
    
  end
end

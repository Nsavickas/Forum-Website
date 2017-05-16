require 'rails_helper'

RSpec.describe Post, type: :model do

  let(:post) {FactoryGirl.create(:post)}
  let(:post_with_comments) {FactoryGirl.create(:post_with_comments)}
  let(:old_post) {FactoryGirl.create(:post, created_at: Time.now - 2.days)}
  
  describe "creation" do
    context "with valid attributes" do
      it "should be valid" do
        expect(post).to be_valid
        expect(post.subforum_id).not_to be_nil
      end
    end

    context "with invalid attributes" do
      it "should not be valid" do
        post.postname = ""
        expect(post).not_to be_valid
      end
    end
  end
  
  describe "post attributes" do
    it {is_expected.to validate_presence_of :postname}
    it {is_expected.to validate_presence_of(:user_id)}
    it {is_expected.to validate_presence_of(:subforum_id)}
    it {is_expected.to validate_presence_of(:content)}
    it {is_expected.to validate_length_of(:content)
      .is_at_least(10).on(:create)}
  end
  
  describe "post associations" do
    it {is_expected.to have_many(:comments)}
    it {is_expected.to have_many(:likes)}
    it {is_expected.to have_many(:pictures)}
    it {is_expected.to belong_to(:user)}
    it {is_expected.to belong_to(:subforum)}
  end
  
  describe "#toggle_sticky" do 
    context "when sticky is false" do 
      it "should return true" do 
        post.toggle_sticky
        expect(post.sticky).to eq(true)
      end
    end
    
    context "when sticky is true" do
      it "should return false" do 
        post = FactoryGirl.build(:post, sticky: true)
        post.toggle_sticky
        expect(post.sticky).to eq(false)
      end
    end
  end
  
  describe ".trending" do 
    context "a trending post" do
      it "should be returned" do
        trending_posts = Post.trending
        expect(trending_posts).to include(post)
      end
    end
    
    context "a non-trending post" do
      it "should not be returned" do 
        trending_posts = Post.trending
        expect(trending_posts).not_to include(old_post)
      end
    end
  end
  
  describe "#total_comments" do 
    it "should equal total comments associated with post" do
      expect(post_with_comments.total_comments).to eq(2)
    end
  end
  
  
end

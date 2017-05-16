require 'rails_helper'

RSpec.describe Subforum, type: :model do
  
  it {is_expected.to validate_presence_of :subforumname}
  it {is_expected.to validate_presence_of :forum_id}
  it {is_expected.to have_many(:posts)}
  it {is_expected.to belong_to(:forum)}
  
  let(:subforum) {FactoryGirl.create(:subforum)}
  let(:subforum_with_posts) {FactoryGirl.create(:subforum_with_posts)}
  
  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        expect(subforum).to be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        subforum.subforumname = ""
        expect(subforum).not_to be_valid
      end
    end
  end
  
  describe "#most_recent_post" do 
    it "should return the newest post" do 
      new_subforum_with_posts = subforum_with_posts
      newest_post = new_subforum_with_posts.most_recent_post
      expect(newest_post).to eq(new_subforum_with_posts.posts.last)
    end
  end
end

require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  let(:comment) {FactoryGirl.build(:comment)}
  
  describe "creation" do 
    context "valid attributes" do
      it "should be valid" do
        expect(comment).to be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        comment.comment_content = ""
        expect(comment).not_to be_valid
      end
    end
  end
  
  describe "comment attributes" do
    it {is_expected.to validate_presence_of(:user_id)}
    it {is_expected.to validate_presence_of(:post_id)}
    it {is_expected.to validate_presence_of(:comment_content)}
    it {is_expected.to validate_length_of(:comment_content)
      .is_at_least(2).on(:create)}
  end
  
  describe "comment associations" do
    it {is_expected.to have_many(:likes)}
    it {is_expected.to have_many(:notifications)}
    it {is_expected.to belong_to(:user)}
    it {is_expected.to belong_to(:post)}
  end
end

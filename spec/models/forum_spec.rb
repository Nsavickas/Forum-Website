require 'rails_helper'

RSpec.describe Forum, type: :model do
  
  it {is_expected.to validate_presence_of :forumname}
  it {is_expected.to have_many(:subforums)}
  
  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        forum = FactoryGirl.build(:forum)
        expect(forum).to be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        forum = FactoryGirl.build(:forum, forumname: "")
        expect(forum).not_to be_valid
      end
    end
  end
  
  
end

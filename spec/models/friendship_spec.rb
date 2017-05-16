require 'rails_helper'

RSpec.describe Friendship, type: :model do
  let(:user1) {FactoryGirl.create(:user, name: 'Jose')}
  let(:user2) {FactoryGirl.create(:user, name: 'Troy')}
  let(:friendship) {FactoryGirl.create(:friendship, friender: user1, friended: user2)}

  describe "creation" do
    context "with valid attributes" do
      it "should be valid" do
        expect(friendship).to be_valid
      end
    end

    context "with invalid attributes" do
      it "should not be valid" do
        friendship.friender_id = ""
        expect(friendship).not_to be_valid
      end
    end
  end
  
  describe "friendship attributes" do
    it {is_expected.to validate_presence_of :friender_id}
    it {is_expected.to validate_presence_of(:friended_id)}
  end
  
  describe "friendship associations" do
    it {is_expected.to have_many(:notifications)}
    it {is_expected.to belong_to(:friender).class_name('User').with_foreign_key('friender_id')}
    it {is_expected.to belong_to(:friended).class_name('User').with_foreign_key('friended_id')}
  end
end

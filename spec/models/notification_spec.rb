require 'rails_helper'

RSpec.describe Notification, type: :model do
  let(:notification) {FactoryGirl.create(:notification)}
  
  describe "creation" do
    context "with valid attributes" do
      it "should be valid" do
        expect(notification).to be_valid
      end
    end

    context "with invalid attributes" do
      it "should not be valid" do
        notification.title = ""
        expect(notification).not_to be_valid
      end
    end
  end
  
  describe "notification attributes" do
    it {is_expected.to validate_presence_of :title}
    it {is_expected.to validate_presence_of(:user_id)}
    it {is_expected.to validate_presence_of(:notifiable_id)}
    it {is_expected.to validate_presence_of(:notifiable_type)}
  end
  
  describe "notification associations" do
    it {is_expected.to belong_to(:notifiable)}
    it {is_expected.to belong_to(:user)}
  end
end

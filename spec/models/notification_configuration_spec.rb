require 'rails_helper'

RSpec.describe NotificationConfiguration, type: :model do
  let(:notification_config) {FactoryGirl.create(:notification_configuration)}
  
  describe "creation" do
    context "with valid attributes" do
      it "should be valid" do
        expect(notification_config).to be_valid
      end
    end

    context "with invalid attributes" do
      it "should not be valid" do
        notification_config.user_id = ""
        expect(notification_config).not_to be_valid
      end
    end
  end
  
  describe "notification config attributes" do
    it {is_expected.to validate_presence_of(:user_id)}
  end
  
  describe "notification config associations" do
    it {is_expected.to belong_to(:user)}
  end
end

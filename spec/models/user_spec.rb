require 'rails_helper'

RSpec.describe User, type: :model do
  describe "creation" do

    context "valid attributes" do
      it "should be valid" do
        user = FactoryGirl.build(:user)
        expect(user).to be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        user = FactoryGirl.build(:user, name: "")
        expect(user).not_to be_valid
      end
    end
  end
  
  describe "user attributes" do
    before do
      #@user = FactoryGirl.create(:user)
    end
    
    it {is_expected.to validate_presence_of :name}
    it {is_expected.to validate_length_of(:name)
      .is_at_most(50).on(:create)
      .is_at_least(3).on(:create)}
      
    it {is_expected.to validate_presence_of(:email)}
    it {is_expected.to validate_length_of(:email)
      .is_at_most(255).on(:create)}
    it {should validate_uniqueness_of(:email)}
    it {is_expected.to allow_value('user@example.com').for(:email)}
    it {is_expected.not_to allow_value('user@example,com').for(:email)}
    
    it "should save email addresses in lower-case" do
      @user = FactoryGirl.create(:user)
      mixed_case_email = "Foo@ExAMPle.CoM"
      @user.email = mixed_case_email
      @user.save
      expect(mixed_case_email.downcase).to eq(@user.reload.email)
    end
    
    it {is_expected.to have_secure_password}  
    it {is_expected.to validate_presence_of :password}
    it {is_expected.to validate_length_of(:password)
      .is_at_least(6).on(:create)} 
  end
  
  describe "user associations" do
    it {is_expected.to have_many(:comments)}
    it {is_expected.to have_many(:notifications)}
    it {is_expected.to have_many(:posts)}
    it {is_expected.to have_many(:items)}
    it {is_expected.to have_many(:pictures)}
    #it {is_expected.to have_many(:friendships).with_foreign_key('friender_id')}
    #it {is_expected.to have_many(:friendships).with_foreign_key('friended_id')}
    it {is_expected.to have_one(:avatar)}
    it {is_expected.to have_one(:notification_configuration)}
    it {is_expected.to have_many(:likes)}
  end
  
  
  
  
end

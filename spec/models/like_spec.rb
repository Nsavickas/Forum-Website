require 'rails_helper'

RSpec.describe Like, type: :model do
   let(:like1){FactoryGirl.create(:duplicate_like)}  
   let(:like2){FactoryGirl.create(:duplicate_like)}
   
   describe "attribute validations" do
    it {is_expected.to validate_presence_of :likeable_id}
    it {is_expected.to validate_presence_of :likeable_type}
    it {is_expected.to validate_presence_of :user_id}
  end
  
  describe "associations" do
    it {is_expected.to have_many :notifications}
    it {is_expected.to belong_to :likeable}
    it {is_expected.to belong_to :user}
  end
  
  describe "#check_duplicate" do 
    it "should be called after save" do 
      expect(like1).to receive(:check_duplicate)
      like1.save
    end
    
    it "prevents creations of duplicate likes" do
      like1.save
      
      expect(like2.save).to raise_error
      like2.save
      expect(:check_duplicate).to eq(true)
    end
  end
end

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe "creation" do
    context "valid attributes" do
      it "should be valid" do
        item = FactoryGirl.build(:car)
        expect(item).to be_valid
      end
    end

    context "invalid attributes" do
      it "should not be valid" do
        item = FactoryGirl.build(:car, itemname: "")
        expect(item).not_to be_valid
      end
    end
  end
  
  describe "item attribute validations" do
    it {is_expected.to validate_presence_of :itemname}
    it {is_expected.to validate_length_of(:itemname)
      .is_at_least(3).on(:create)}
    it {is_expected.to validate_presence_of :category}
    it {is_expected.to validate_presence_of :price}
    #it {is_expected.to validate_numericality_of(:price)}
    it {is_expected.to validate_presence_of :stock}
    #it {is_expected.to validate_numericality_of(:stock)}
    it {is_expected.to validate_presence_of :user_id}
  end
  
  describe "item associations" do
    it {is_expected.to have_many :pictures}
    it {is_expected.to belong_to :user}
  end
end

require 'rails_helper'

RSpec.describe Picture, type: :model do
  it {is_expected.to validate_presence_of :image}
  it {is_expected.to validate_presence_of :imageable_id}
  it {is_expected.to validate_presence_of :imageable_type}
  
  it {is_expected.to belong_to :imageable}
end

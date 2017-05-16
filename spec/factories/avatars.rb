FactoryGirl.define do
  factory :avatar do
    displaypic { File.new("#{Rails.root}/spec/support/fixtures/lleyn.jpg") } 
    association :user
    created_at {Time.now}
  end

end

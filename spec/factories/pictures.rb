FactoryGirl.define do
  factory :post_picture, class: Picture do
    association :imageable, factory: :post_with_pictures
    image { File.new("#{Rails.root}/spec/support/fixtures/nc.jpg") }
    default_image false
    created_at {Time.now}
  end
  
  factory :user_picture, class: Picture do
    association :imageable, factory: :user_with_pictures
    image { File.new("#{Rails.root}/spec/support/fixtures/nc.jpg") }
    default_image false
    created_at {Time.now}
  end

end

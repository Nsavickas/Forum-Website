ThinkingSphinx::Index.define :item, :with => :active_record do
  # fields
  indexes itemname, :sortable => true
  indexes category

  # attributes
  has created_at, price
end
json.array!(@comments) do |comment|
  json.extract! comment, :id, :body, :attachment, :created_at, :updated_at
end

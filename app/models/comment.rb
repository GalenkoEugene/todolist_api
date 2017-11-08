class Comment < ApplicationRecord
  belongs_to :task, counter_cache: true
  mount_base64_uploader :attachment, AttachmentUploader
  validates :body, length: { in: 10..256 },
                   presence: true
end

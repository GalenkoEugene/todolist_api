class AttachmentUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog

  def store_dir
    return 'dev' if Rails.env.development?
    'todolist'
  end

  def cache_dir
    Rails.root.join('tmp', 'cache', 'images')
  end

  def extension_whitelist
    %w[jpg jpeg png]
  end

  version :thumb do
    process resize_to_fit: [250, 250]
  end

  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  private

  def secure_token
    file_name = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(file_name) || model.instance_variable_set(file_name, SecureRandom.uuid)
  end
end

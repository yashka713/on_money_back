require "shrine"

if Rails.env.test?
  require "shrine/storage/memory"

  Shrine.storages = {
      cache: Shrine::Storage::Memory.new,
      receipt: Shrine::Storage::Memory.new,
  }
# elsif Rails.env.development?
#   require "shrine/storage/file_system"
#
#   Shrine.storages = {
#       cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
#       receipt: Shrine::Storage::FileSystem.new("public", prefix: "uploads/receipt")
#   }
else
  require "shrine/storage/s3"

  s3_options = {
      access_key_id:     ENV.fetch("AWS_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
      region:            ENV.fetch("AWS_REGION"),
      bucket:            ENV.fetch("AWS_BUCKET"),
  }

  s3_receipt_storage = Shrine::Storage::S3.new(
      prefix: "receipt",
      upload_options: { acl: "private" }, **s3_options
  )

  Shrine.storages = {
      cache: Shrine::Storage::S3.new(prefix: "cache", **s3_options),
      receipt: s3_receipt_storage,
  }
end

Shrine.logger = Rails.logger

Shrine.plugin :activerecord # for AR integration
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # for pulling metadata after a direct upload
Shrine.plugin :derivatives

unless Rails.env.production?
  Shrine.plugin :upload_endpoint
  Shrine.plugin :determine_mime_type
end

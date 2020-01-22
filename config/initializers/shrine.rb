require "shrine"

if Rails.env.test?
  require "shrine/storage/memory"

  Shrine.storages = {
      cache: Shrine::Storage::Memory.new,
      store: Shrine::Storage::Memory.new,
      video: Shrine::Storage::Memory.new,
  }
elsif Rails.env.development?
  require "shrine/storage/file_system"

  Shrine.storages = {
      cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"),
      store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"),
      video: Shrine::Storage::FileSystem.new("public", prefix: "uploads/videos"),
  }
else
  require "shrine/storage/s3"
  require "shrine/storage/imgix"

  s3_options = {
      access_key_id:     ENV.fetch("AWS_ACCESS_KEY_ID"),
      secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
      region:            ENV.fetch("AWS_REGION"),
      bucket:            ENV.fetch("AWS_BUCKET"),
  }

  cache_storage = Shrine::Storage::S3.new(
      prefix: "cache",
      upload_options: { acl: "public-read" }, **s3_options
  )

  s3_video_storage = Shrine::Storage::S3.new(
      prefix: "videos",
      upload_options: { acl: "private" }, **s3_options
  )

  s3_store_storage = Shrine::Storage::S3.new(
      prefix: "store",
      upload_options: { acl: "public-read" }, **s3_options
  )

  imgix_storage = Shrine::Storage::Imgix.new(
      storage:          s3_store_storage,
      include_prefix:   true, # set to false if you have prefix configured in Imgix source
      api_key:          ENV.fetch("IMGIX_API_KEY"),
      host:             ENV.fetch("IMGIX_HOST"), # Imgix::Client options
      )

  Shrine.storages = {
      cache: cache_storage,
      store: imgix_storage,
      video: s3_video_storage,
  }
end

Shrine.logger = Rails.logger

Shrine.plugin :activerecord # for AR integration
Shrine.plugin :remote_url, max_size: 20 * 1024 * 1024 # remote_url support, max 20mb
Shrine.plugin :restore_cached_data # for pulling metadata after a direct upload
Shrine.plugin :keep_files, destroyed: true, replaced: true # for keeping files

if Rails.env.production?
  Shrine.plugin :presign_endpoint, presign_options: -> (request) {
    # Uppy will send the "filename" and "type" query parameters
    filename = request.params["filename"]
    type     = request.params["type"]
    {
        content_disposition: "inline; filename=\"#{filename}\"", # set download filename
        content_type: type,                                       # set content type
        content_length_range: 0..(10 * 1024 * 1024 * 1024),       # limit upload size to 10 GB
    }
  }
else
  Shrine.plugin :upload_endpoint
  Shrine.plugin :determine_mime_type
end

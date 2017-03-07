puts "Using #{MiniMagick.cli}"
CarrierWave.configure do |config|
  if ['development', 'test'].include?(Rails.env)
    config.storage = :file
    if Rails.env.test?
      config.enable_processing = false
    end
  else
    config.fog_credentials = {
      :provider               => 'AWS',                        # required
      :aws_access_key_id      => ENV['AWS_KEY'],                        # required
      :aws_secret_access_key  => ENV['AWS_SECRET']                        # required
    }
    config.fog_directory  = ENV['AWS_BUCKET'] || "sc-pong-#{Rails.env}"

    config.cache_dir = "#{Rails.root}/tmp/uploads"
    config.storage = :fog
  end
end

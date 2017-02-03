require 'cf-app-utils'

if Rails.env.production?
  CF::App::Environment.set!(
      [
          {
              'name' => 'SECRET_KEY_BASE',
              'method' => 'name',
              'parameter' => 'secrets',
              'key' => 'key_base'
          },
          {
              'name' => 'AWS_KEY',
              'method' => 'name',
              'parameter' => 'AWS_S3',
              'key' => 'key'
          },
          {
              'name' => 'AWS_SECRET',
              'method' => 'name',
              'parameter' => 'AWS_S3',
              'key' => 'secret'
          },
          {
              'name' => 'AWS_BUCKET',
              'method' => 'name',
              'parameter' => 'AWS_S3',
              'key' => 'bucket'
          },
          {
              'name' => 'admin_username',
              'method' => 'name',
              'parameter' => 'admin_account',
              'key' => 'username'
          },
          {
              'name' => 'admin_password',
              'method' => 'name',
              'parameter' => 'admin_account',
              'key' => 'password'
          }
      ]
  )
end
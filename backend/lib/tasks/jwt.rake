namespace :jwt do
  desc "Generate a JWT with a given sub parameter"
  task :generate, [:sub] => :environment do |t, args|
    require 'jwt'

    args.with_defaults(sub: nil)

    if args[:sub].nil?
      puts "Error: You must provide a sub parameter."
      exit 1
    end

    secret_key = Rails.application.credentials.secret_key_base
    payload = { sub: args[:sub], exp: 24.hours.from_now.to_i }

    token = JWT.encode(payload, secret_key, 'HS256')

    puts token
  end
end
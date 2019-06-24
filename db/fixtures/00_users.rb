User.seed_once(:name) do |user|
  user.id = 1
  user.password = 'Passw1'
  user.email = 'example@example.com'
  user.name = 'demo'
  user.nickname = 'demo'
end

puts 'User successfully added'

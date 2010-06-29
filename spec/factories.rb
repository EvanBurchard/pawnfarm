Factory.define :user do |u|
  u.sequence(:login) {|n| "user#{n}"}
  u.email {|a| "#{a.login}@hotbananas.com"}
  u.password "secret"
  u.password_confirmation "secret"
end

Factory.define :user_session do |u|
  u.login "registered_user"
  u.password "secret"
end

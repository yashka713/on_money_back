ActiveRecord::Schema.define(version: 20_181_203_104_538) do
  enable_extension 'plpgsql'

  create_table 'accounts', force: :cascade do |t|
    t.bigint 'user_id'
    t.string 'name'
    t.float 'balance'
    t.string 'note'
    t.string 'currency'
    t.integer 'status', default: 0
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_accounts_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'nickname'
    t.string 'email'
    t.string 'password_digest'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
  end
end

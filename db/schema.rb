# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_181_205_142_610) do
  # These are extensions that must be enabled in order to support this database
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

  create_table 'transactions', force: :cascade do |t|
    t.string 'chargeable_type'
    t.bigint 'chargeable_id'
    t.string 'profitable_type'
    t.bigint 'profitable_id'
    t.bigint 'user_id'
    t.integer 'operation_type'
    t.float 'amount'
    t.string 'note'
    t.datetime 'date'
    t.index %w[chargeable_type chargeable_id], name: 'index_transactions_on_chargeable_type_and_chargeable_id'
    t.index %w[profitable_type profitable_id], name: 'index_transactions_on_profitable_type_and_profitable_id'
    t.index ['user_id'], name: 'index_transactions_on_user_id'
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

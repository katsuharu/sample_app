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

ActiveRecord::Schema.define(version: 20181013075130) do

  create_table "authorizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider", "uid"], name: "index_authorizations_on_provider_and_uid", unique: true, using: :btree
  end

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "hira"
    t.string   "kana"
    t.integer  "lock_version", default: 0, null: false, comment: "ロックバージョン"
  end

  create_table "chats", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "text",         limit: 65535,                          comment: "テキスト"
    t.integer  "user_id",                                             comment: "ユーザーID"
    t.integer  "pair_id",                                             comment: "ペアID"
    t.date     "lunch_date",                                          comment: "ランチ日時"
    t.datetime "deleted_at",                                          comment: "削除日時"
    t.integer  "lock_version",               default: 0, null: false, comment: "ロックバージョン"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.datetime "sent_at",                                             comment: "投稿通知メール送信時刻"
  end

  create_table "daily_lunches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                     null: false, comment: "ランチテーマ"
    t.date     "date",                     null: false, comment: "ランチ日時"
    t.integer  "category_id",              null: false, comment: "カテゴリーID"
    t.datetime "deleted_at",                            comment: "削除日時"
    t.integer  "lock_version", default: 0, null: false, comment: "ロックバージョン"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "first_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "lock_version", default: 0, null: false, comment: "ロックバージョン"
  end

  create_table "forth_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "third_category_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "lock_version",      default: 0, null: false, comment: "ロックバージョン"
  end

  create_table "lunches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.integer  "pair_id"
    t.boolean  "is_deleted"
    t.datetime "deleted_at"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.date     "lunch_date"
    t.datetime "canceled_at"
    t.integer  "lock_version", default: 0, null: false, comment: "ロックバージョン"
    t.datetime "sent_at",                               comment: "送信日時"
    t.integer  "friends_num",  default: 0, null: false, comment: "一緒に参加する友達人数"
  end

  create_table "second_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "first_category_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "lock_version",      default: 0, null: false, comment: "ロックバージョン"
  end

  create_table "t_threads", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "content",      limit: 65535
    t.integer  "user_id"
    t.integer  "tweet_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "lock_version",               default: 0, null: false, comment: "ロックバージョン"
  end

  create_table "third_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "second_category_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "lock_version",       default: 0, null: false, comment: "ロックバージョン"
  end

  create_table "tweets", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "content",      limit: 65535
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "lock_version",               default: 0, null: false, comment: "ロックバージョン"
  end

  create_table "user_hobbies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "user_id"
    t.integer  "hobby_id"
    t.string   "hobby_name"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "lock_version", default: 0, null: false, comment: "ロックバージョン"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "email"
    t.string   "department_name"
    t.string   "slack_id"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",         default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.string   "profile_img"
    t.integer  "position_id"
    t.string   "self_intro"
    t.integer  "any_category"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.string   "hobby"
    t.integer  "hobby_added"
    t.datetime "deleted_at",                                     comment: "削除日時"
    t.integer  "lock_version",      default: 0,     null: false, comment: "ロックバージョン"
    t.boolean  "admin",             default: false, null: false, comment: "管理者"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

end

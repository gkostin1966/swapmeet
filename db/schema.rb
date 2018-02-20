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

ActiveRecord::Schema.define(version: 20180111204101) do

  create_table "categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "display_name"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "domains", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "display_name"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_domains_on_parent_id"
  end

  create_table "gatekeepers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "role"
    t.bigint "domain_id"
    t.bigint "group_id"
    t.bigint "listing_id"
    t.bigint "newspaper_id"
    t.bigint "publisher_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role_type"
    t.string "role_id"
    t.string "subject_type"
    t.string "subject_id"
    t.string "verb_type"
    t.string "verb_id"
    t.string "object_type"
    t.string "object_id"
    t.index ["domain_id"], name: "index_gatekeepers_on_domain_id"
    t.index ["group_id"], name: "index_gatekeepers_on_group_id"
    t.index ["listing_id"], name: "index_gatekeepers_on_listing_id"
    t.index ["newspaper_id"], name: "index_gatekeepers_on_newspaper_id"
    t.index ["publisher_id"], name: "index_gatekeepers_on_publisher_id"
    t.index ["user_id"], name: "index_gatekeepers_on_user_id"
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "display_name"
    t.bigint "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_groups_on_parent_id"
  end

  create_table "groups_newspapers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "newspaper_id", null: false
    t.bigint "group_id", null: false
    t.index ["group_id", "newspaper_id"], name: "index_groups_newspapers_on_group_id_and_newspaper_id"
    t.index ["newspaper_id", "group_id"], name: "index_groups_newspapers_on_newspaper_id_and_group_id"
  end

  create_table "groups_publishers", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "publisher_id", null: false
    t.bigint "group_id", null: false
    t.index ["group_id", "publisher_id"], name: "index_groups_publishers_on_group_id_and_publisher_id"
    t.index ["publisher_id", "group_id"], name: "index_groups_publishers_on_publisher_id_and_group_id"
  end

  create_table "groups_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id", null: false
    t.bigint "group_id", null: false
    t.index ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id"
    t.index ["user_id", "group_id"], name: "index_groups_users_on_user_id_and_group_id"
  end

  create_table "listings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.string "body"
    t.bigint "owner_id"
    t.bigint "newspaper_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_listings_on_category_id"
    t.index ["newspaper_id"], name: "index_listings_on_newspaper_id"
    t.index ["owner_id"], name: "index_listings_on_owner_id"
  end

  create_table "newspapers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "display_name"
    t.bigint "publisher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["publisher_id"], name: "index_newspapers_on_publisher_id"
  end

  create_table "newspapers_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "newspaper_id", null: false
    t.bigint "user_id", null: false
    t.index ["newspaper_id", "user_id"], name: "index_newspapers_users_on_newspaper_id_and_user_id"
    t.index ["user_id", "newspaper_id"], name: "index_newspapers_users_on_user_id_and_newspaper_id"
  end

  create_table "publishers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "display_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "domain_id"
    t.index ["domain_id"], name: "index_publishers_on_domain_id"
  end

  create_table "publishers_users", id: false, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "publisher_id", null: false
    t.bigint "user_id", null: false
    t.index ["publisher_id", "user_id"], name: "index_publishers_users_on_publisher_id_and_user_id"
    t.index ["user_id", "publisher_id"], name: "index_publishers_users_on_user_id_and_publisher_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username"
    t.string "display_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "gatekeepers", "domains"
  add_foreign_key "gatekeepers", "groups"
  add_foreign_key "gatekeepers", "listings"
  add_foreign_key "gatekeepers", "newspapers"
  add_foreign_key "gatekeepers", "publishers"
  add_foreign_key "gatekeepers", "users"
  add_foreign_key "listings", "categories"
  add_foreign_key "listings", "users", column: "owner_id"
end

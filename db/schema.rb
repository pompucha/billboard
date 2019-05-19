ActiveRecord::Schema.define(version: 2019_05_16_215957) do

  enable_extension "plpgsql"

  create_table "billboards", force: :cascade do |t|
    t.string "ustop"
    t.string "eurotop"
    t.string "top"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end

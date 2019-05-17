class CreateBillboards < ActiveRecord::Migration[5.2]
  def change
    create_table :billboards do |t|
      t.string :ustop
      t.string :eurotop
      t.string :top

      t.timestamps
    end
  end
end

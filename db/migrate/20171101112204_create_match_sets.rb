class CreateMatchSets < ActiveRecord::Migration[5.0]
  def change
    create_table :match_sets do |t|
      t.integer :rso1_id
      t.integer :rso2_id
      t.integer :rso3_id
      t.integer :rso4_id
      t.integer :rso5_id
    end
  end
end

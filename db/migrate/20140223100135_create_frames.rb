class CreateFrames < ActiveRecord::Migration
  def change
    create_table :frames do |t|
      t.integer :game_id
      t.integer :ball_1
      t.integer :ball_2
      t.integer :ball_3
      t.integer :points
      t.integer :number_frame, :default => 1

      t.timestamps
    end
  end
end

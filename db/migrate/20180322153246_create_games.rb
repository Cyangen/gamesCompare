class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :name
      t.string :search
      t.string :kinguinPrice
      t.string :instantGamingPrice
      t.string :g2aPrice

      t.timestamps
    end
  end
end

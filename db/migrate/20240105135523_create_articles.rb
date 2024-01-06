class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    create_table :articles do |t|
      t.string :title
      t.string :description
      t.text :body
      t.string :tag_list
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

class AddSlugToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :slug, :string
  end
end

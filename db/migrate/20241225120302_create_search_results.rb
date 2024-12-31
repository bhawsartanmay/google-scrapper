class CreateSearchResults < ActiveRecord::Migration[7.0]
  def change
    create_table :search_results do |t|
      t.references :keyword, null: false, foreign_key: true
      t.integer :total_ads
      t.integer :total_links
      t.string :total_results
      t.text :html_cache

      t.timestamps
    end
  end
end

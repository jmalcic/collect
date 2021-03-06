# frozen_string_literal: true

class CreateSpinaConferencesEvents < ActiveRecord::Migration[6.0] # :nodoc:
  def change
    create_table :spina_conferences_events do |t|
      t.datetime :start_datetime
      t.datetime :finish_datetime
      t.references :conference, foreign_key: { to_table: :spina_conferences_conferences, on_delete: :cascade }

      t.timestamps
    end
  end
end

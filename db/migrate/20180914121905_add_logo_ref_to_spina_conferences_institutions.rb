# frozen_string_literal: true

class AddLogoRefToSpinaConferencesInstitutions < ActiveRecord::Migration[5.2] # :nodoc:
  def change
    add_reference :spina_conferences_institutions, :logo, foreign_key: { to_table: :spina_images }
  end
end

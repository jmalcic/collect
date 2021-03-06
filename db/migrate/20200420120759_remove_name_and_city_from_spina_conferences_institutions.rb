# frozen_string_literal: true

class RemoveNameAndCityFromSpinaConferencesInstitutions < ActiveRecord::Migration[6.0] # :nodoc:
  def change
    remove_column :spina_conferences_institutions, :name, :string
    remove_column :spina_conferences_institutions, :city, :string
  end
end

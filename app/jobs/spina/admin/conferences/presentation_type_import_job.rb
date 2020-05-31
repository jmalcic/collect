# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This job imports presentation types from CSV files
      class PresentationTypeImportJob < ImportJob
        queue_as :default

        def perform(csv)
          PresentationType.transaction do
            import(csv) do |row|
              room_possessions = row[:room_possessions]
              copy_value :conference, from: row, to: room_possessions
              PresentationType.create! name: row[:name], minutes: row[:minutes],
                                       conference: find_conference(row[:conference]),
                                       room_possessions: find_room_possessions(room_possessions)
            end
          end
        end
      end
    end
  end
end
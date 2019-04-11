# frozen_string_literal: true

module Spina
  module Conferences
    # This job imports presentations from CSV files
    class PresentationImportJob < ImportJob
      include ::Spina::Conferences

      queue_as :default

      def perform(csv)
        Presentation.transaction do
          import(csv) do |row|
            room_use = row[:room_use]
            copy_value :conference, from: row, to: room_use
            Presentation.create! title: row[:title], date: row[:date], start_time: row[:start_time],
                                 abstract: row[:abstract], presenters: find_delegates(row[:presenters]),
                                 room_use: find_room_use(room_use)
          end
        end
      end
    end
  end
end
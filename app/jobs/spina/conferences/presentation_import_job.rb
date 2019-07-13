# frozen_string_literal: true

module Spina
  module Conferences
    # This job imports presentations from CSV files
    class PresentationImportJob < ImportJob
      include ::Spina::Conferences
      include Pageable

      queue_as :default

      def perform(csv)
        Presentation.transaction do
          import(csv) do |row|
            room_use = row[:room_use]
            copy_value :conference, from: row, to: room_use
            Presentation.create! title: row[:title], date: row[:date], start_time: row[:start_time],
                                 abstract: row[:abstract], presenters: find_delegates(row[:presenters]),
                                 room_use: find_room_use(room_use), parts: theme_parts
          end
        end
      end

      private

      def theme_parts
        presentation = Presentation.new
        model_parts(Presentation).map { |part| presentation.part(part) }
      end
    end
  end
end

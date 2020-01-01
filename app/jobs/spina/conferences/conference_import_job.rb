# frozen_string_literal: true

module Spina
  module Conferences
    # This job imports conferences from CSV files
    class ConferenceImportJob < ImportJob
      include Pageable

      queue_as :default

      def perform(csv)
        Conference.transaction do
          import(csv) do |row|
            rooms = row[:rooms]
            copy_value :institution, from: row, to: rooms
            Conference.create! institution: find_institution(row[:institution]), start_date: row[:start_date],
                               finish_date: row[:finish_date], rooms: find_rooms(rooms), parts: theme_parts
          end
        end
      end

      private

      def theme_parts
        conference_model_parts = model_parts(Conference)
        conference = Conference.new
        conference_model_parts.blank? ? nil : conference_model_parts.map { |part| conference.part(part) }
      end
    end
  end
end

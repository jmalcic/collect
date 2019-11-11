# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class PresentationTypesTest < ApplicationSystemTestCase
        setup do
          @presentation_type = spina_conferences_presentation_types :plenary_1
          @user = spina_users :joe
          visit admin_login_url
          fill_in 'email', with: @user.email
          fill_in 'password', with: 'password'
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_presentation_types_url
          assert_selector '.breadcrumbs', text: 'Presentation type'
        end

        test 'creating a presentation type' do
          visit admin_conferences_presentation_types_url
          click_on 'New presentation type'
          select @presentation_type.conference.name, from: 'presentation_type_conference_id'
          fill_in 'presentation_type_name', with: @presentation_type.name
          fill_in 'presentation_type_minutes', with: @presentation_type.minutes
          @presentation_type.room_possessions.each do |room_possession|
            select room_possession.room_name, from: 'presentation_type_room_possession_ids'
          end
          click_on 'Save presentation type'
          assert_text 'Presentation type saved'
        end

        test 'updating a presentation type' do
          visit admin_conferences_presentation_types_url
          within "tr[data-presentation-type-id=\"#{@presentation_type.id}\"]" do
            click_on('Edit')
          end
          select @presentation_type.conference.name, from: 'presentation_type_conference_id'
          fill_in 'presentation_type_name', with: @presentation_type.name
          fill_in 'presentation_type_minutes', with: @presentation_type.minutes
          @presentation_type.room_possessions.each do |room_possession|
            select room_possession.room_name, from: 'presentation_type_room_possession_ids'
          end
          click_on 'Save presentation type'
          assert_text 'Presentation type saved'
        end

        test 'destroying a presentation type' do
          visit admin_conferences_presentation_types_url
          within "tr[data-presentation-type-id=\"#{@presentation_type.id}\"]" do
            click_on('Edit')
          end
          click_on 'Permanently delete'
          click_on 'Yes, I\'m sure'
          assert_no_selector "tr[data-presentation-type-id=\"#{@presentation_type.id}\"]"
        end
      end
    end
  end
end

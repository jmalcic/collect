# frozen_string_literal: true

require 'application_system_test_case'

module Spina
  module Admin
    module Conferences
      class InstitutionsTest < ApplicationSystemTestCase
        setup do
          @institution = spina_admin_conferences_institutions :university_of_atlantis
          @user = spina_users :joe
          visit admin_login_url
          fill_in 'email', with: @user.email
          fill_in 'password', with: 'password'
          click_on 'Login'
        end

        test 'visiting the index' do
          visit admin_conferences_institutions_url
          assert_selector '.breadcrumbs', text: 'Institutions'
          Percy.snapshot page, name: 'Institutions index'
        end

        test 'creating an institution' do
          visit admin_conferences_institutions_url
          click_on 'New institution'
          assert_selector '.breadcrumbs', text: 'New institution'
          page.execute_script '$.fx.off = true;'
          fill_in 'admin_conferences_institution_name', with: @institution.name
          fill_in 'admin_conferences_institution_city', with: @institution.city
          click_on 'Choose image'
          upload_and_select_image file_fixture('dubrovnik.jpeg')
          Percy.snapshot page, name: 'Institutions form on create'
          click_on 'Save institution'
          assert_text 'Institution saved'
          Percy.snapshot page, name: 'Institutions index on create'
        end

        test 'updating an institution' do
          visit admin_conferences_institutions_url
          within "tr[data-institution-id=\"#{@institution.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs', text: @institution.name
          Percy.snapshot page, name: 'Institutions form on update'
          fill_in 'admin_conferences_institution_name', with: @institution.name
          fill_in 'admin_conferences_institution_city', with: @institution.city
          page.execute_script '$.fx.off = true;'
          click_on 'Choose image'
          upload_and_select_image file_fixture('dubrovnik.jpeg')
          click_on 'Save institution'
          assert_text 'Institution saved'
          Percy.snapshot page, name: 'Institutions index on update'
        end

        test 'destroying an institution' do
          visit admin_conferences_institutions_url
          within "tr[data-institution-id=\"#{@institution.id}\"]" do
            click_on 'Edit'
          end
          assert_selector '.breadcrumbs', text: @institution.name
          page.execute_script '$.fx.off = true;'
          click_on 'Permanently delete'
          find '#overlay', visible: true, style: { display: 'block' }
          assert_text "Are you sure you want to delete the institution #{@institution.name}?"
          Percy.snapshot page, name: 'Institutions delete dialog'
          click_on 'Yes, I\'m sure'
          assert_text 'Institution deleted'
          assert_no_selector "tr[data-institution-id=\"#{@institution.id}\"]"
          Percy.snapshot page, name: 'Institutions index on delete'
        end

        def upload_and_select_image(fixture)
          attach_file 'image_files', fixture, make_visible: true
          first('.gallery .item:not(.item-uploader)').click
          find('.gallery-select-sidebar').click_on 'Choose image'
          assert_no_selector '#overlay'
        end
      end
    end
  end
end

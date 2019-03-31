require 'test_helper'

module Spina
  module Admin
    class DelegatesControllerTest < ActionDispatch::IntegrationTest
      include Engine.routes.url_helpers
      include ::Spina::Conferences

      setup do
        @delegate = spina_conferences_delegates :joe_bloggs
        @user = spina_users :joe
        post admin_sessions_url, params: { email: @user.email, password: 'password' }
      end

      test 'should get index' do
        get admin_conferences_delegates_url
        assert_response :success
      end

      test 'should get new' do
        get new_admin_conferences_delegate_url
        assert_response :success
      end

      test 'should create delegate' do
        assert_difference('Delegate.count') do
          attributes = @delegate.attributes
          attributes[:conference_ids] = @delegate.conferences.collect(&:id)
          post admin_conferences_delegates_url, params: { delegate: attributes }
        end

        assert_redirected_to admin_conferences_delegates_url
      end

      test 'should get edit' do
        get edit_admin_conferences_delegate_url(@delegate)
        assert_response :success
      end

      test 'should update delegate' do
        patch admin_conferences_delegate_url(@delegate), params: { delegate: @delegate.attributes }
        assert_redirected_to admin_conferences_delegates_url
      end

      test 'should destroy delegate' do
        assert_difference('Delegate.count', -1) do
          delete admin_conferences_delegate_url(@delegate)
        end

        assert_redirected_to admin_conferences_delegates_url
      end
    end
  end
end

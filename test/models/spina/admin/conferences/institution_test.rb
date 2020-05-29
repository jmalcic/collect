# frozen_string_literal: true

require 'test_helper'

module Spina
  module Admin
    module Conferences
      class InstitutionTest < ActiveSupport::TestCase
        setup { @institution = spina_admin_conferences_institutions :university_of_atlantis }

        test 'institution attributes must not be empty' do
          institution = Institution.new
          assert institution.invalid?
          assert institution.errors[:name].any?
          assert institution.errors[:city].any?
        end
      end
    end
  end
end

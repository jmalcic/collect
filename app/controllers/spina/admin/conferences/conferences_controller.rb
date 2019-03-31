# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages conferences and sets breadcrumbs
      class ConferencesController < ::Spina::Admin::AdminController
        include ::Spina::Conferences

        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        def index
          @conferences = Conference.sorted
        end

        def show
          @conference = Conference.find params[:id]
        end

        def new
          @conference = params[:conference] ? Conference.new(conference_params) : Conference.new
          add_breadcrumb I18n.t('spina.conferences.conferences.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @conference = Conference.find params[:id]
          add_breadcrumb @conference.name
          render layout: 'spina/admin/admin'
        end

        def create
          @conference = Conference.new(conference_params)
          add_breadcrumb I18n.t('spina.conferences.conferences.new')
          if @conference.save
            redirect_to admin_conferences_conferences_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @conference = Conference.find params[:id]
          set_update_breadcrumb
          if @conference.update(conference_params)
            redirect_to admin_conferences_conferences_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @conference = Conference.find params[:id]
          @conference.destroy
          redirect_to admin_conferences_conferences_path
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.conferences.website.conferences'), admin_conferences_conferences_path
        end

        def set_update_breadcrumb
          add_breadcrumb @conference.name if @conference
        end

        def set_tabs
          @tabs = %w[conference_details delegates presentation_types rooms presentations]
        end

        def conference_params
          params.require(:conference).permit(:start_date, :finish_date, :institution_id, room_ids: [])
        end
      end
    end
  end
end

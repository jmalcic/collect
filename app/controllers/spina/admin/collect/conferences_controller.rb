# frozen_string_literal: true

module Spina
  module Admin
    module Collect
      # This class manages conferences and sets breadcrumbs
      class ConferencesController < AdminController
        before_action :set_breadcrumbs
        before_action :set_tabs, only: %i[new create edit update]

        def index
          @conferences = Spina::Collect::Conference.sorted
        end

        def show
          @conference = Spina::Collect::Conference.find params[:id]
          respond_to do |format|
            format.json do
              render json: { dates: dates,
                             presentation_types: presentation_types }
            end
          end
        end

        def new
          @conference = Spina::Collect::Conference.new
          add_breadcrumb I18n.t('spina.collect.conferences.new')
          render layout: 'spina/admin/admin'
        end

        def edit
          @conference = Spina::Collect::Conference.find params[:id]
          add_breadcrumb @conference.institution_and_year
          render layout: 'spina/admin/admin'
        end

        def create
          @conference = Spina::Collect::Conference.new(conference_params)
          add_breadcrumb I18n.t('spina.collect.conferences.new')
          if @conference.save
            redirect_to admin_collect_conferences_path
          else
            render :new, layout: 'spina/admin/admin'
          end
        end

        def update
          @conference = Spina::Collect::Conference.find params[:id]
          add_breadcrumb @conference.institution_and_year
          if @conference.update(conference_params)
            redirect_to admin_collect_conferences_path
          else
            render :edit, layout: 'spina/admin/admin'
          end
        end

        def destroy
          @conference = Spina::Collect::Conference.find params[:id]
          @conference.destroy
          redirect_to admin_collect_conferences_path
        end

        private

        def set_breadcrumbs
          add_breadcrumb I18n.t('spina.collect.website.conferences'), admin_collect_conferences_path
        end

        def set_tabs
          @tabs = %w[conference_details delegates presentation_types rooms presentations]
        end

        def conference_params
          params.require(:conference).permit(:start_date, :finish_date,
                                             :institution_id)
        end

        def dates
          @conference.dates.to_a.collect do |date|
            { label: l(date, format: :short), date: date }
          end
        end

        def presentation_types
          @conference.presentation_types
        end
      end
    end
  end
end

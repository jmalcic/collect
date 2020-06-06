# frozen_string_literal: true

module Spina
  module Admin
    module Conferences
      # This class manages presentation types
      class PresentationTypesController < ApplicationController
        before_action :set_presentation_type, only: %i[edit update destroy]
        before_action :set_breadcrumbs
        before_action :set_tabs

        layout 'spina/admin/conferences/conferences'

        def index
          @presentation_types = PresentationType.sorted
        end

        def new
          @presentation_type = PresentationType.new
          add_breadcrumb t('.new')
        end

        def edit
          add_breadcrumb @presentation_type.name
        end

        def create
          @presentation_type = PresentationType.new presentation_type_params

          if @presentation_type.save
            redirect_to admin_conferences_presentation_types_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb t('.new')
                render :new
              end
              format.js { render partial: 'errors', locals: { errors: @presentation_type.errors } }
            end
          end
        end

        def update
          if @presentation_type.update(presentation_type_params)
            redirect_to admin_conferences_presentation_types_path, success: t('.saved')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @presentation_type.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @presentation_type.errors } }
            end
          end
        end

        def destroy
          if @presentation_type.destroy
            redirect_to admin_conferences_presentation_types_path, success: t('.destroyed')
          else
            respond_to do |format|
              format.html do
                add_breadcrumb @presentation_type.name
                render :edit
              end
              format.js { render partial: 'errors', locals: { errors: @presentation_type.errors } }
            end
          end
        end

        private

        def set_presentation_type
          @presentation_type = PresentationType.find params[:id]
        end

        def set_breadcrumbs
          add_breadcrumb Conference.model_name.human(count: 0), admin_conferences_conferences_path
          add_breadcrumb PresentationType.model_name.human(count: 0), admin_conferences_presentation_types_path
        end

        def set_tabs
          @tabs = %w[presentation_type_details presentations sessions]
        end

        def presentation_type_params
          params.require(:admin_conferences_presentation_type).permit(:name, :conference_id, :minutes)
        end
      end
    end
  end
end

module Api
  module V1
    class TechnologiesController < ApplicationController
      # TODO: Api::V1::ApiController
      def index
        @technologies = Technology.all
      end

      def create
        names_arr = params[:names].split ','

        @technologies = Technology.find_or_create_many(names_arr)
        render :index
      end

      def show
        @technologies = Technology.find(params[:id])
        render :show
      end
    end
  end
end

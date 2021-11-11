module Api
  module Concerns
    module Filterable
      def filter!(resource)
        store_filters(resource)
        apply_filters(resource)
      end

      private

      def store_filters(resource)
        # Originalmente usaba las keys en la session
        # Para que los filtros se reinicien se usa una variable
        @filters = {} if @filters.blank?
        filter_name = "#{resource.to_s.underscore}_filters"
        unless @filters.key?(filter_name)
          @filters[filter_name] =
            {}
        end

        @filters[filter_name].merge!(filter_params_for(resource))
      end

      def filter_params_for(resource)
        new_params = params.permit(resource::FILTER_PARAMS)
        resource::ARRAY_FILTER_PARAMS.each do |filter|
          new_params.merge! params.permit(filter => [])
        end
        new_params
      end

      # :reek:FeatureEnvy
      def apply_filters(resource)
        resource.filter(@filters["#{resource.to_s.underscore}_filters"])
      end
    end
  end
end

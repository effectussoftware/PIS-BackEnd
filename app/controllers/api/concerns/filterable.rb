module Filterable
  def filter!(resource)
    store_filters(resource)
    apply_filters(resource)
  end

  private

  def store_filters(resource)
    filter_name = "#{resource.to_s.underscore}_filters"
    unless session.key?(filter_name)
      session[filter_name] =
        {}
    end

    session[filter_name].merge!(filter_params_for(resource))
  end

  def filter_params_for(resource)
    params.permit(resource::FILTER_PARAMS)
  end

  # :reek:FeatureEnvy
  def apply_filters(resource)
    resource.filter(session["#{resource.to_s.underscore}_filters"])
  end
end

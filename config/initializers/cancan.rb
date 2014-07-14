# https://github.com/ryanb/cancan/issues/835
module CanCan
  class ControllerResource
    alias_method :original_resource_params_by_namespaced, :resource_params_by_namespaced_name

    def resource_params_by_namespaced_name
      if (@controller && @params && @params[:action] == "create")
        strong_params =  @controller.method("#{namespaced_name.name.downcase}_params".to_sym)
        params = strong_params.call if defined? strong_params
      end
      params ||=  original_resource_params_by_namespaced
    end
  end
end

class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    private
        def inline?
            return params.has_key?(:inline) && (params[:inline].nil? || ActiveRecord::Type::Boolean.new.cast(params[:inline]))
        end
end

class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    private
        def inline?
            return params.has_key?(:inline) && (params[:inline].nil? || ActiveRecord::Type::Boolean.new.cast(params[:inline]))
        end
        def paging(total, size = 10)
            @offset = 0
            @page = 0
            @size = size
            unless params[:size].nil?
                @size = params[:size].to_i
                @size = [@size, 200].min
            end

            unless params[:page].nil?
                @page = params[:page].to_i - 1
                @offset = @page * @size
            end
            if @page < 0
                @page = 0
                return false
            end
    
            @pages = [total / @size + [1, total % @size].min, 1].max
    
            if @pages <= @page
                return false
            end
    
            @pagination
            if @pages < 8
                @pagination = 1..@pages
            elsif @page < 4
                @pagination = [1, 2, 3, 4, 5, '..', @pages]
            elsif @page > @pages-4
                @pagination = [1, '..', @pages-4, @pages-3, @pages-2, @pages-1, @pages]
            else
                @pagination = [1, '..', @page, @page+1, @page+2, '..', @pages]
            end

            return true
        end
end

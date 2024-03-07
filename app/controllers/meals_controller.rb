class MealsController < ApplicationController
    def index
        @today = Date.today

        @current = Date.commercial(@today.cwyear, @today.cweek, 1)
        if not params[:start].nil?
            parsed = Date.iso8601(params[:start])
            @start = start_of_week (parsed)
        else
            @start = @current
        end

        @end = @start + 6

        @meals = Meal.where(day: @start..@end).order(:day)

        render "index"
    end
    def new
        @recipes = Recipe.all
        @meal = Meal.new
        if not params[:day].nil?
            @meal.day = Date.iso8601(params[:day])
        end

        if inline?
            render '_form', layout: false
        else
            render "edit"
        end
    end
    def create
        @meal = Meal.new()
        @meal.day = Date.iso8601(meal_params[:day])
        @meal.recipe = Recipe.where(title: meal_params[:recipe]).first

        if @meal.save
            redirect_to meals_path(:start => start_of_week(@meal.day))
        else
            render status: :unprocessable_entity
        end
    end
    def edit
        @recipes = Recipe.all
        @meal = Meal.find(params[:id])

        if inline?
            render '_form', layout: false
        else
            render "edit"
        end
    end
    def update
        @meal = Meal.find(params[:id])
        unless meal_params[:day].nil?
            @meal.day = meal_params[:day]
        end
        unless meal_params[:recipe].nil?
            @meal.recipe = Recipe.where(title: meal_params[:recipe]).first!
        end

        if @meal.save
            redirect_to meals_path({start: Date.today})
        else
            render status: :unprocessable_entity
        end
    end
    def destroy
        meal = Meal.find(params[:id])
        if meal.destroy
            head :no_content unless params[:redirect]
            redirect_to meals_path({start: start_of_week(meal.day)})
        else 
            render status: :unprocessable_entity
        end
    end
    private
        def meal_params
            params[:meal].permit(:day, :recipe)
        end
        def start_of_week (date)
            return Date.commercial(date.cwyear, date.cweek, 1)
        end
end

class HomeController < ApplicationController
    def index
        @todays_meals = Meal.where(day: Date.today);
        @tomorrows_meals = Meal.where(day: Date.tomorrow);

    end
end

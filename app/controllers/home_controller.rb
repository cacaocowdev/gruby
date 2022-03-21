class HomeController < ApplicationController
    def index
        @todays_meals = Meal.where(day: Date.today);
        @tomorrows_meals = Meal.where(day: Date.tomorrow);

        @finances_selected = 'week'
        if ['day', 'week', 'month', 'year', 'all'].include?(params[:finances])
            @finances_selected = params[:finances]
        end

        case @finances_selected
        when 'day'
            dura = Date.today
        when 'month'
            dura = Date.new(Date.today.year, Date.today.month)...Date.new(Date.today.year, Date.today.month).next_month
        when 'year'
            dura = Date.new(Date.today.year)..Date.new(Date.today.year, 12, 31)
        when 'all'
            dura = Date.new(0)..Date.new(9999)
        else # week
            dura = Date.commercial(Date.today.cwyear, Date.today.cweek)..Date.commercial(Date.today.cwyear, Date.today.cweek, 7)
        end
        @finances = Transaction.group(:category).where(date: dura).select(:category, 'SUM(amount) as amount').order('SUM(amount)');
        @total = Transaction.where(date: dura).select('SUM(amount) as amount').order('SUM(amount)').first;
    end
end

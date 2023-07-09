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
            duraB = Date.yesterday
        when 'month'
            dura = Date.new(Date.today.year, Date.today.month)...Date.new(Date.today.year, Date.today.month).next_month
            duraB = Date.new(Date.today.year, Date.today.month).last_month...Date.new(Date.today.year, Date.today.month)
        when 'year'
            dura = Date.new(Date.today.year)..Date.new(Date.today.year, 12, 31)
            duraB = Date.new(Date.today.year-1)..Date.new(Date.today.year-1, 12, 31)
        when 'all'
            dura = Date.new(0)..Date.new(9999)
        else # week
            dura = Date.commercial(Date.today.cwyear, Date.today.cweek)..Date.commercial(Date.today.cwyear, Date.today.cweek, 7)
            duraB = Date.commercial(Date.today.cwyear, Date.today.cweek)-7..Date.commercial(Date.today.cwyear, Date.today.cweek, 7)-7
        end
        currentDura = Transaction.group(:category).where(date: dura).select(:category, 'SUM(amount) as amount').order('SUM(amount)');
        oldDura = Transaction.group(:category).where(date: duraB).select(:category, 'SUM(amount) as amount').order('SUM(amount)');
        
        adapter = ActiveRecord::Base.connection_db_config.configuration_hash[:adapter]
        case adapter
        when 'sqlite3'
            ifNullFunc = 'IFNULL'
        when 'postgresql'
            ifNullFunc = 'COALESCE'
        end
        @finances = Transaction.find_by_sql("SELECT " + ifNullFunc + "(t1.category, t2.category)  as category, t1.amount as amount, t2.amount as id FROM (" +  currentDura.to_sql() + ") as t1 FULL OUTER JOIN (" + oldDura.to_sql() + ") as t2 ON t1.category = t2.category")
        @total = Transaction.where(date: dura).select('SUM(amount) as amount').order('SUM(amount)').first;
        @oldTotal = Transaction.where(date: duraB).select('SUM(amount) as amount').order('SUM(amount)').first;

        @tasks = Todo.where(:done => false).limit(7).order(:due => :asc)
    end
end

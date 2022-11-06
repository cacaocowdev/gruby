class TodoMailer < ApplicationMailer
    def weekly_list
        user = params[:mail]
        
        today = Date.today
        @start = Date.commercial(today.cwyear, today.cweek+1, 1)
        @endDate = Date.commercial(today.cwyear, today.cweek+1, 7)
        @tasks = Todo.where(:done => false, :due => @start..@endDate)

        mail(:to => user, :subject => 'ToDo: Weekly reminder')
    end
end

# Preview all emails at http://localhost:3000/rails/mailers/todo_mailer
class TodoMailerPreview < ActionMailer::Preview
    def weekly_list
        TodoMailer.with(mail: 'test@test').weekly_list
    end
end

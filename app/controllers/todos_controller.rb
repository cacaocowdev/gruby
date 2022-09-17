class TodosController < ApplicationController
    def index
        paged = paging(Todo.all.size)
        if not paged
            redirect_to todos_path(size: @size, page: @pages)
            return
        end

        @todos = todoQuery

        @new_todo = Todo.new(:due => Time.now)

        if not params[:id].nil?
            @task = Todo.find(params[:id])
            @task_list = Todo.where(:title => @task.title).where.not(:id => params[:id]).order(:due => :desc)
        end
    end
    def show
        @task = Todo.find(params[:id])
        @task_list = Todo.where(:title => @task.title).where.not(:id => params[:id]).order(:due => :desc)

        if params[:inline]
            render '_show-inline'
        else
            redirect_to todos_path(:id => params[:id])
        end
    end
    def create
        @todo = Todo.new(todo_params)
        print("Before valid")
        unless @todo.valid?
            if inline?
                print("Invalid inline")
                render '_form', status: :bad_request, locals: { todo: @todo }
            else
                print("Invalid normal")
                render 'edit', status: :bad_request
            end
            return
        end

        if inline?
            head :ok
            return
        end

        if @todo.save
            redirect_to todos_path(id: @todo.id) 
        else
            render 'edit', layout: inline?, status: :bad_request
        end
    end
    def update
        todo = Todo.find(params[:id])
        if inline?
            if todo.valid?
                head :ok
            else 
                head :bad_request
            end
            return
        end
        todo.update(todo_params)
        redirect_to todos_path(:id => params[:id])
    end
    def new
        @todo = Todo.new()
        render 'new'
    end
    def edit
        @todo = Todo.find(params[:id])
        render 'edit'
    end
    def destroy
        Todo.destroy(params[:id])
        redirect_to todos_path
    end
    private
        def todo_params
            params.require(:todo).permit(:title, :body, :due, :done)
        end
        def todoQuery
            adapter = ActiveRecord::Base.connection_db_config.configuration_hash[:adapter]
            case adapter
            when 'sqlite3'
                tasks_not_done = Todo.where(:done => false).order(:due => :asc).to_a
                tasks_done = Todo.where(:done => true).order(:due => :desc).to_a
                return (tasks_not_done + tasks_done)[@offset...@offset+@size]
            when 'postgresql'
                tasks_not_done = Todo.where(:done => false).order(:due => :asc)
                tasks_done = Todo.where(:done => true).order(:due => :desc)
                return Todo.find_by_sql(["(#{tasks_not_done.to_sql}) UNION ALL (#{tasks_done.to_sql}) LIMIT ? OFFSET ?", @size, @offset])
            end
        end
end

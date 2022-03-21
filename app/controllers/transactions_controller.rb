class TransactionsController < ApplicationController
    def index
        offset = 0
        @page = 0
        @size = 50
        unless params[:size].nil?
            @size = params[:size].to_i
            @size = [@size, 200].min
        end
        unless params[:page].nil?
            @page = params[:page].to_i - 1
            offset = @page * @size
        end

        if @page < 0
            @page = 0
            redirect_to transactions_path(size: @size)
            return
        end

        @pages = [Transaction.all.size / @size + [1, Transaction.all.size % @size].min, 1].max

        if @page > 0 and @pages <= @page
            redirect_to transactions_path(size: @size, page: @pages)
            return
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

        @transactions = Transaction.order(:date => :desc).offset(offset).limit(@size)
        @transaction = Transaction.new
        @uses = Transaction.select(:use).group(:use).to_a.map { |t| t.use }
        @categories = Transaction.select(:category).group(:category).to_a.map { |t| t.category }
    end
    def new
        @transaction = Transaction.new({income: income?, date: Date.today})
        @uses = Transaction.select(:use).group(:use).to_a.map { |t| t.use }
        @categories = Transaction.select(:category).group(:category).to_a.map { |t| t.category }

        if inline?
            render '_form', layout: false
            return
        end
    end
    def create
        t_params = transaction_params
        amount = (t_params[:amount].to_f * 100).to_i.abs
        if !ActiveRecord::Type::Boolean::new.cast(t_params[:income])
            amount = -amount
        end

        t_params[:amount] = amount
        transaction = Transaction.new(t_params)
        if transaction.save
            redirect_to transactions_path
        else
            head :bad_request
        end
    end
    def edit
        @transaction = Transaction.find(params[:id])
        @uses = Transaction.select(:use).group(:use).to_a.map { |t| t.use }
        @categories = Transaction.select(:category).group(:category).to_a.map { |t| t.category }

        if inline?
            render '_form', layout: false
            return
        end
    end
    def update
        transaction = Transaction.find(params[:id])

        t_params = transaction_params
        amount = (t_params[:amount].to_f * 100).to_i.abs
        if !ActiveRecord::Type::Boolean::new.cast(t_params[:income])
            amount = -amount
        end

        t_params[:amount] = amount
        
        if transaction.update(t_params)
            redirect_to transactions_path
        else
            head :bad_request
        end
    end
    def destroy
        transaction = Transaction.find(params[:id])
        transaction.destroy

        redirect_to transactions_path(size: params[:size], page: params[:page])
    end

    private
        def transaction_params
            params.require(:transaction).permit(:date, :category, :use, :amount, :income)
        end
        def income?
            return params.has_key?(:income) && (params[:income].nil? || ActiveRecord::Type::Boolean.new.cast(params[:income]))
        end
end

class TransactionsController < ApplicationController
    def index
        paged = paging(Transaction.all.size, 50)
        if not paged
            redirect_to transactions_path(size: @size, page: @pages)
            return
        end

        @transactions = Transaction.order(:date => :desc).offset(@offset).limit(@size)
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

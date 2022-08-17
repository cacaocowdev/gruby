class FinancesController < ApplicationController
    def home
        @range = 'month'
        if ['month', 'year', 'all'].include?(params[:range])
            @range = params[:range]
        end

        @transform = 'normal'
        if ['normal', 'absolute', 'inverted'].include?(params[:transform])
            @transform = params[:transform]
        end

        @group = 'category'
        if ['category', 'date'].include?(params[:group])
            @group = params[:group]
        end

        case @range
        when 'year'
            para = group_by_year
        when 'month'
            para = group_by_month
        else
            para = nil
        end

        start_timeframe = params[:start]
        if not start_timeframe.nil? and not start_timeframe.empty?
            @start_timeframe = Date.parse(start_timeframe)
        end

        end_timeframe = params[:end]
        if not end_timeframe.nil? and not end_timeframe.empty?
            @end_timeframe = Date.parse(end_timeframe)
        end

        @category_filter = params[:category]
        if @category_filter.nil?
            @category_filter = []
        end

        @category_statistics = Transaction.group(para, :category)
            .select(:category, transform_select('SUM(transactions.amount)', @transform) + ' as amount', (if not para.nil? then "DATE(#{para}) as dupe" else '\'All time\' as dupe' end))
            .where(where_date(@start_timeframe, @end_timeframe), {start: start_timeframe, end: end_timeframe})

        @total_statistics = Transaction.group(para)
            .select(transform_select('SUM(transactions.amount)', @transform) + ' as amount', (if not para.nil? then "DATE(#{para}) as dupe" else '\'All time\' as dupe' end))
            .where(where_date(@start_timeframe, @end_timeframe), {start: start_timeframe, end: end_timeframe})

        unless @category_filter.empty?
            @category_statistics = @category_statistics.where({category: @category_filter})
            @total_statistics = @total_statistics.where({category: @category_filter})
        end

        # If no timeframe is given only the most recent 6 lines will be displayed
        # showing all lines can have a significant impact on performance
        if @start_timeframe.nil? and @end_timeframe.nil?
            @total_statistics = @total_statistics.limit(6)
        end

        @category_statistics = @category_statistics.order(Arel.sql("dupe DESC")).to_a

        @categories = @category_statistics.map{ |s| s.category }.uniq
        
        @total_statistics = @total_statistics.order(Arel.sql("dupe DESC")).to_a

        @dates = @total_statistics.map{ |s| s.dupe }.uniq

        render 'index'
    end
    private
        def group_by_month
            adapter = ActiveRecord::Base.connection_db_config.configuration_hash[:adapter]
            case adapter
            when 'sqlite3'
                return 'SUBSTR(transactions.date, 0, 8)'
            when 'postgresql'
                return 'date_trunc(\'month\', transactions.date)'
            end
        end
        def group_by_year
            adapter = ActiveRecord::Base.connection_db_config.configuration_hash[:adapter]
            case adapter
            when 'sqlite3'
                return 'SUBSTR(transactions.date, 0, 5)'
            when 'postgresql'
                return 'date_trunc(\'year\', transactions.date)'
            end
        end
        def where_date(start_tf, end_tf)
            clause = '1=1'
            if not start_tf.nil? and not end_tf.nil?
                clause = 'date BETWEEN :start AND :end'
            elsif not start_tf.nil?
                clause = 'date >= :start'
            elsif not end_tf.nil?
                clause = 'date <= :end'
            end
            return clause
        end
        def transform_select(str, transform)
            case transform
            when 'normal'
                return str
            when 'absolute'
                return "ABS(#{str})"
            when 'inverted'
                return "-#{str}"
            end
        end
end
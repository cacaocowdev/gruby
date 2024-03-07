class RecipesController < ApplicationController
    def index

        recipes = Recipe.all.order("LOWER(title)")

        last_cooked = Meal.group(:recipe_id).where(day: ...Date.today).select("MAX(day) as last_cooked", :recipe_id)
        next_cook = Meal.group(:recipe_id).where(day: Date.today...).select("MIN(day) as next_cook", :recipe_id)

        @recipes = Recipe.find_by_sql("SELECT * FROM (SELECT * FROM (" + recipes.to_sql + ") as r FULL OUTER JOIN (" + last_cooked.to_sql + ") as m1 ON r.id = m1.recipe_id) as r2 FULL OUTER JOIN (" + next_cook.to_sql + ") as m2 ON r2.id = m2.recipe_id");
        if not params[:id].nil?
            @recipe = Recipe.find(params[:id])
        end

        @new_recipe = Recipe.new
    end

    def show
        @recipe = Recipe.find(params[:id])

        if params[:inline]
            render '_show-inline'
        else
            render 'show'
        end
    end

    def new
        @recipe = Recipe.new()

        render 'edit'
    end

    def edit
        @recipe = Recipe.find(params[:id])
    end

    def add
        @recipe = Recipe.find(params[:id])

        render 'add'
    end

    def create
        @recipe = Recipe.new(recipe_params)
        picture = params[:recipe][:picture]

        unless @recipe.valid_with_picture?(picture)
            if inline?
                render '_form', status: :bad_request, locals: { recipe: @recipe }
            else
                render 'edit', status: :bad_request
            end
            return
        end

        if inline?
            head :ok
            return
        end

        if @recipe.save
            unless picture.nil?
                @recipe.picture.attach(picture)
                picture.original_filename = Random.alphanumeric + Recipe.extensions[picture.content_type]
            end
            redirect_to recipes_path(id: @recipe.id) 
        else
            render 'edit', layout: inline?, status: :bad_request
        end
    end

    def destroy
        @recipe = Recipe.find(params[:id])
        @recipe.destroy

        redirect_to recipes_path
    end

    def update
        if inline?
            head :ok
            return
        end

        @recipe = Recipe.find(params[:id])

        unless recipe_params[:title].nil?
            @recipe.title = recipe_params[:title]
        end

        unless recipe_params[:body].nil?
            @recipe.body = recipe_params[:body]
        end

        picture = params[:recipe][:picture]
        unless @recipe.valid_with_picture?(picture)
            head :bad_request
            return
        end

        unless picture.nil?
            if @recipe.picture.attached?
                @recipe.picture.purge
            end
            picture.original_filename = Random.alphanumeric + Recipe.extensions[picture.content_type]
            @recipe.picture.attach(picture)
        end

        @recipe.save
        redirect_to recipe_path(@recipe)
    end

    private
        def recipe_params
            params.require(:recipe).permit(:title, :body, :picture)
        end
end

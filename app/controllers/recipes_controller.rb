class RecipesController < ApplicationController
    def index
        @recipes = Recipe.all
        if not params[:id].nil?
            @recipe = Recipe.find(params[:id])
        end

        @new_recipe = Recipe.new
    end

    def show
        @recipe = Recipe.find(params[:id])
        @ingredients = Ingredient.all

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
        @ingredients = Ingredient.all

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
            @recipe.picture.attach(picture)
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

        unless recipe_params[:ingredients].nil?
            recipe_params[:ingredients].each do |ingredient|
                @recipe.ingredients << Ingredient.where(name: ingredient).first
            end
        end

        unless recipe_params[:ingredientsRemove].nil?
            recipe_params[:ingredientsRemove].each do |ingredient_id|
                @recipe.ingredients.delete(Ingredient.find(ingredient_id))
            end
        end

        unless recipe_params[:title].nil?
            @recipe.title = recipe_params[:title]
        end

        unless recipe_params[:body].nil?
            @recipe.body = recipe_params[:body]
        end

        unless @recipe.valid_with_picture?(params[:recipe][:picture])
            head :bad_request
            return
        end

        unless params[:recipe][:picture].nil?
            if @recipe.picture.attached?
                @recipe.picture.purge
            end
            @recipe.picture.attach(params[:recipe][:picture])
        end

        @recipe.save
        redirect_to recipe_path(@recipe)
    end

    private
        def recipe_params
            params.require(:recipe).permit(:title, :body, :picture, ingredients: [], ingredientsRemove: [])
        end
end

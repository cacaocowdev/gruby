class IngredientsController < ApplicationController
  def index
    @ingredient = Ingredient.new()
    @classForIngredients = "active"
    @ingredients = Ingredient.all
  end

  def show
    @ingredient = Ingredient.find(params[:id])
  end

  def new
    @ingredient = Ingredient.new()
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)

    if @ingredient.save
        redirect_to ingredients_path 
    else
        render status: :unprocessable_entity
    end
  end

  def destroy
    @ingredient = Ingredient.find(params[:id])
    @ingredient.destroy

    redirect_to ingredients_path
  end

  private
    def ingredient_params
        params.require(:ingredient).permit(:name)
    end
end

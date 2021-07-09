class RecipesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  def show
    recipes = Recipe.all
    render json: recipes
  end

  def index  
    recipes = User.find(session[:user_id]).recipes
    render json: recipes, include: :user
  end

  def create
    recipe = User.find(session[:user_id]).recipes.create!(recipe_params)
    render json: recipe, include: :user, status: :created
  end

  private

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end

  def record_not_found
    render json: { errors: ["Not Logged In"] }, status: :unauthorized
  end

  def render_unprocessable_entity_response(invalid)
    puts "in invalid response"
    render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity 
  end

end

class CategoriesController < ApplicationController


  def new
    @category = Category.new
  end

  def create
    # render text: params
    @category = Category.new category_params
    @category.save
    redirect_to categories_path 
  end

  def show
    @category = Category.find(params[:id])
  end


  def index
    @categories = Category.all
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update category_params
      redirect_to Categories_path
    else :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path

  end


  private
  def category_params 
    params.require(:category).permit(:title)
  end










end

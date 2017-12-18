# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :set_policy

  def index
    @policy.authorize! :index?
    @categories = Category.all
  end

  def show
    @policy.authorize! :show?
  end

  def new
    @policy.authorize! :new?
    @category = Category.new
  end

  def edit
    @policy.authorize! :edit?
  end

  def create
    @policy.authorize! :create?
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @policy.authorize! :update?
    respond_to do |format|
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @policy.authorize! :destroy?
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Authorization Policy
    def set_policy
      @policy = CategoriesPolicy.new(PolicyAgent.new(:User, current_user), PolicyAgent.new(:Category, @category))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # # Never trust parameters from the scary internet, only allow the white list through.
    # def category_params
    #   params.fetch(:category, {})
    # end
    # Never trust parameters from the scary internet, only allow the white list through.
    def category_params
      params.require(:category).permit(:name, :display_name, :title)
    end
end
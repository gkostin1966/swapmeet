# frozen_string_literal: true

class CategoriesController < ApplicationController
  def index
    @policy.authorize! :index?
    @categories = Category.all
    @categories = CategoriesPresenter.new(current_user, @policy, @categories)
  end

  def show
    @policy.authorize! :show?
    @category = CategoryPresenter.new(current_user, @policy, @category)
  end

  def new
    @policy.authorize! :new?
    @category = Category.new
    @category = CategoryPresenter.new(current_user, @policy, @category)
  end

  def edit
    @policy.authorize! :edit?
    @category = CategoryPresenter.new(current_user, @policy, @category)
  end

  def create
    @policy.authorize! :create?
    @category = Category.new(category_params)
    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html do
          @category = CategoryPresenter.new(current_user, @policy, @category)
          render :new
        end
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
        format.html do
          @category = CategoryPresenter.new(current_user, @policy, @category)
          render :edit
        end
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
    def new_policy
      @category = Category.find(params[:id]) if params[:id].present?
      CategoriesPolicy.new([SubjectPolicyAgent.new(:User, current_user), CategoryPolicyAgent.new(@category)])
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

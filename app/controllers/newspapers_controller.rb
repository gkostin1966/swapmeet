# frozen_string_literal: true

class NewspapersController < ApplicationController
  def index
    @policy.authorize! :index?
    @newspapers = Newspaper.all
    @newspapers = @newspapers.map { |newspaper| NewspaperPresenter.new(current_user, @policy, newspaper) }
  end

  def show
    @policy.authorize! :show?
    @newspaper = NewspaperPresenter.new(current_user, @policy, @newspaper)
  end

  def new
    @publisher = Publisher.find(params[:publisher_id]) if params[:publisher_id].present?
    @policy.authorize! :new?
    @newspaper = Newspaper.new
    # @newspaper = NewspaperPresenter.new(current_user, @policy, @newspaper)
  end

  def edit
    @publisher = Publisher.find(params[:publisher_id]) if params[:publisher_id].present?
    @policy.authorize! :edit?
    # @newspaper = NewspaperPresenter.new(current_user, @policy, @newspaper)
  end

  def create
    @publisher = Publisher.find(newspaper_params[:publisher_id]) if newspaper_params[:publisher_id].present?
    @policy.authorize! :create?
    @newspaper = Newspaper.new(newspaper_params)
    respond_to do |format|
      if @newspaper.save
        format.html { redirect_to @newspaper, notice: 'Newspaper was successfully created.' }
        format.json { render :show, status: :created, location: @newspaper }
      else
        format.html do
          # @newspaper = NewspaperPresenter.new(current_user, @policy, @newspaper)
          render :new
        end
        format.json { render json: @newspaper.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @policy.authorize! :update?
    respond_to do |format|
      if @newspaper.update(newspaper_params)
        format.html { redirect_to @newspaper, notice: 'Newspaper was successfully updated.' }
        format.json { render :show, status: :ok, location: @newspaper }
      else
        format.html do
          # @newspaper = NewspaperPresenter.new(current_user, @policy, @newspaper)
          render :edit
        end
        format.json { render json: @newspaper.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @policy.authorize! :destroy?
    @newspaper.destroy
    respond_to do |format|
      format.html { redirect_to newspapers_url, notice: 'Newspaper was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Authorization Policy
    def new_policy
      @newspaper = Newspaper.find(params[:id]) if params[:id].present?
      NewspapersPolicy.new(SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Newspaper, @newspaper))
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def newspaper_params
      params.require(:newspaper).permit(:name, :display_name, :publisher_id)
    end
end

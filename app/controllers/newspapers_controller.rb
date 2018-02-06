# frozen_string_literal: true

class NewspapersController < ApplicationController
  def index
    @policy.authorize! :index?
    if params[:publisher_id].present?
      @publisher = Publisher.find(params[:publisher_id])
      @newspapers = @publisher.newspapers.all
      @publisher = PublisherPresenter.new(current_user, PublishersPolicy.new(@policy.agents.push(ObjectPolicyAgent.new(:Publisher, @publisher))), @publisher)
      @policy.agents[-1], @policy.agents[-2] = @policy.agents[-2], @policy.agents[-1]
      @newspapers = NewspapersPresenter.new(current_user, @policy, @newspapers)
      render "publishers/newspapers/index"
    else
      @newspapers = Newspaper.all
      @newspapers = NewspapersPresenter.new(current_user, @policy, @newspapers)
      render
    end
  end

  def show
    @policy.authorize! :show?
    if params[:publisher_id].present?
      @publisher = Publisher.find(params[:publisher_id])
      @publisher = PublisherPresenter.new(current_user, PublishersPolicy.new(@policy.agents.push(ObjectPolicyAgent.new(:Publisher, @publisher))), @publisher)
      @policy.agents[-1], @policy.agents[-2] = @policy.agents[-2], @policy.agents[-1]
      @newspaper = NewspaperPresenter.new(current_user, @policy, @newspaper)
      render "publishers/newspapers/show"
    else
      @newspaper = NewspaperPresenter.new(current_user, @policy, @newspaper)
    end
  end

  def new
    @publisher = Publisher.find(params[:publisher_id]) if params[:publisher_id].present?
    @policy.authorize! :new?
    @newspaper = Newspaper.new
    @newspaper = NewspaperPresenter.new(current_user, @policy, @newspaper)
  end

  def edit
    @publisher = Publisher.find(params[:publisher_id]) if params[:publisher_id].present?
    @policy.authorize! :edit?
    @newspaper = NewspaperPresenter.new(current_user, @policy, @newspaper)
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
          @newspaper = NewspaperPresenter.new(current_user, @policy, @newspaper)
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
          @newspaper = NewspaperPresenter.new(current_user, @policy, @newspaper)
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

  def add
    publisher = Publisher.find(params[:publisher_id])
    publisher.newspapers << @newspaper
    respond_to do |format|
      format.html { redirect_to publisher_newspapers_path(publisher), notice: 'Newspaper was successfully added..' }
      format.json { head :no_content }
    end
  end

  def remove
    publisher = Publisher.find(params[:publisher_id])
    publisher.newspapers.delete(@newspaper)
    respond_to do |format|
      format.html { redirect_to publisher_newspapers_path(publisher), notice: 'Newspaper was successfully removed.' }
      format.json { head :no_content }
    end
  end

  private
    # Authorization Policy
    def new_policy
      @newspaper = Newspaper.find(params[:id]) if params[:id].present?
      NewspapersPolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Newspaper, @newspaper)])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def newspaper_params
      params.require(:newspaper).permit(:name, :display_name, :publisher_id)
    end
end

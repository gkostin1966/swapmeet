# frozen_string_literal: true

class PublishersController < ApplicationController
  def index
    @policy.authorize! :index?
    @publishers = Publisher.all
    @publishers = PublishersPresenter.new(current_user, @policy, @publishers)
  end

  def show
    @policy.authorize! :show?
    @publisher = PublisherPresenter.new(current_user, @policy, @publisher)
  end

  def new
    @policy.authorize! :new?
    @publisher = Publisher.new
    @publisher = PublisherPresenter.new(current_user, @policy, @publisher)
  end

  def edit
    @policy.authorize! :edit?
    @publisher = PublisherPresenter.new(current_user, @policy, @publisher)
  end

  def create
    @policy.authorize! :create?
    @publisher = Publisher.new(publisher_params)
    respond_to do |format|
      if @publisher.save
        format.html { redirect_to @publisher, notice: 'Publisher was successfully created.' }
        format.json { render :show, status: :created, location: @publisher }
      else
        format.html do
          @publisher = PublisherPresenter.new(current_user, @policy, @publisher)
          render :new
        end
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @policy.authorize! :update?
    respond_to do |format|
      if @publisher.update(publisher_params)
        format.html { redirect_to @publisher, notice: 'Publisher was successfully updated.' }
        format.json { render :show, status: :ok, location: @publisher }
      else
        format.html do
          @publisher = PublisherPresenter.new(current_user, @policy, @publisher)
          render :edit
        end
        format.json { render json: @publisher.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @policy.authorize! :destroy?
    @publisher.destroy
    respond_to do |format|
      format.html { redirect_to publishers_url, notice: 'Publisher was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Authorization Policy
    def new_policy
      @publisher = Publisher.find(params[:id]) if params[:id].present?
      PublishersPolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Publisher, @publisher)])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def publisher_params
      params.require(:publisher).permit(:name, :display_name, :domain_id)
    end
end

# frozen_string_literal: true

class DomainsController < ApplicationController
  def index
    @policy.authorize! :index?
    @domains = Domain.all
    @domains = DomainsPresenter.new(current_user, @policy, @domains)
  end

  def show
    @policy.authorize! :show?
    @domain = DomainPresenter.new(current_user, @policy, @domain)
  end

  def new
    @policy.authorize! :new?
    @domain = Domain.new
    @domain = DomainPresenter.new(current_user, @policy, @domain)
  end

  def edit
    @policy.authorize! :edit?
    @domain = DomainPresenter.new(current_user, @policy, @domain)
  end

  def create
    @policy.authorize! :create?
    @domain = Domain.new(domain_params)
    respond_to do |format|
      if @domain.save
        format.html { redirect_to @domain, notice: 'Domain was successfully created.' }
        format.json { render :show, status: :created, location: @domain }
      else
        format.html do
          @domain = DomainPresenter.new(current_user, @policy, @domain)
          render :new
        end
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @policy.authorize! :update?
    respond_to do |format|
      if @domain.update(domain_params)
        format.html { redirect_to @domain, notice: 'Domain was successfully updated.' }
        format.json { render :show, status: :ok, location: @domain }
      else
        format.html do
          @domain = DomainPresenter.new(current_user, @policy, @domain)
          render :edit
        end
        format.json { render json: @domain.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @policy.authorize! :destroy?
    @domain.destroy
    respond_to do |format|
      format.html { redirect_to domains_url, notice: 'Domain was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Authorization Policy
    def new_policy
      @domain = Domain.find(params[:id]) if params[:id].present?
      DomainsPolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Domain, @domain)])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def domain_params
      params.require(:domain).permit(:name, :display_name, :parent_id)
    end
end

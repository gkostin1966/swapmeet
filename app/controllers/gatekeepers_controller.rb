# frozen_string_literal: true

class GatekeepersController < ApplicationController
  def index
    @policy.authorize! :index?
    @gatekeepers = Gatekeeper.all
  end

  def show
    @policy.authorize! :show?
  end

  def new
    @policy.authorize! :new?
    @gatekeeper = Gatekeeper.new
  end

  def edit
    @policy.authorize! :edit?
  end

  def create
    @policy.authorize! :create?
    @gatekeeper = Gatekeeper.new(gatekeeper_params)
    respond_to do |format|
      if @gatekeeper.save
        format.html { redirect_to @gatekeeper, notice: 'Gatekeeper was successfully created.' }
        format.json { render :show, status: :created, location: @gatekeeper }
      else
        format.html { render :new }
        format.json { render json: @gatekeeper.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @policy.authorize! :update?
    respond_to do |format|
      if @gatekeeper.update(gatekeeper_params)
        format.html { redirect_to @gatekeeper, notice: 'Gatekeeper was successfully updated.' }
        format.json { render :show, status: :ok, location: @gatekeeper }
      else
        format.html { render :edit }
        format.json { render json: @gatekeeper.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @policy.authorize! :destroy?
    @gatekeeper.destroy
    respond_to do |format|
      format.html { redirect_to gatekeepers_url, notice: 'Gatekeeper was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Authorization Policy
    def new_policy
      @gatekeeper = Gatekeeper.find(params[:id]) if params[:id].present?
      GatekeepersPolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Gatekeeper, @gatekeeper)])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def gatekeeper_params
      params.require(:gatekeeper).permit(:role, :domain_id, :group_id, :listing_id, :newspaper_id, :publisher_id, :user_id)
    end
end

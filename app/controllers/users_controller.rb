# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :show, :update, :destroy, :login, :join, :leave]
  before_action :set_policy, except: [:login, :logout]

  def create
    @policy.authorize! :create?
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @policy.authorize! :destroy?
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def edit
    @policy.authorize! :edit?
  end

  def index
    @policy.authorize! :index?
    @users = User.all
  end

  def join
    @policy.authorize! :join?
    group_id = params[:group_id]
    group = Group.find(group_id)
    group.users << @user
    respond_to do |format|
      format.html { redirect_to groups_path, notice: 'User was successfully added to group.' }
      format.json { head :no_content }
    end
  end

  def leave
    @policy.authorize! :leave?
    group_id = params[:group_id]
    group = Group.find(group_id)
    group.users.delete(@user)
    respond_to do |format|
      format.html { redirect_to groups_path, notice: 'User was successfully removed from group.' }
      format.json { head :no_content }
    end
  end

  def login
    auto_login(@user)
    redirect_to root_path
  end

  def logout
    logout!
    redirect_to root_path
  end

  def new
    @policy.authorize! :new?
    @user = User.new
  end

  def show
    @policy.authorize! :show?
  end

  def update
    @policy.authorize! :update?
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def set_user
      @user ||= User.find(params[:id])
    end

    def set_policy
      @policy ||= UsersPolicy.new(PolicyAgent.new(:User, current_user), PolicyAgent.new(:User, @user))
    end

    def user_params
      params.require(:user).permit(:display_name, :email)
    end
end

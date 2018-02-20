# frozen_string_literal: true

class UsersController < ApplicationController
  def index
    @policy.authorize! :index?

    if params[:publisher_id].present?
      @publisher = Publisher.find(params[:publisher_id])
      @publisher = PublisherPresenter.new(current_user, PublishersPolicy.new(@policy.agents.push(ObjectPolicyAgent.new(:Publisher, @publisher))), @publisher)
      @policy.agents[-1], @policy.agents[-2] = @policy.agents[-2], @policy.agents[-1]
      if params[:newspaper_id].present?
        @newspaper = Newspaper.find(params[:newspaper_id])
        @newspaper = NewspaperPresenter.new(current_user, NewspapersPolicy.new(@policy.agents.push(ObjectPolicyAgent.new(:Newspaper, @newspaper))), @newspaper)
        @policy.agents[-1], @policy.agents[-2] = @policy.agents[-2], @policy.agents[-1]
        @users = @newspaper.model.users.order(email: :asc)
        @users = @publisher.model.users.order(email: :asc) if @policy.add? || @policy.remove?
        @users = UsersPresenter.new(current_user, @policy, @users)
        render "publishers/newspapers/users/index"
      else
        @users = @publisher.model.users.order(email: :asc)
        @users = User.order(email: :asc) if @policy.add? || @policy.remove?
        @users = UsersPresenter.new(current_user, @policy, @users)
        render "publishers/users/index"
      end
    elsif params[:newspaper_id].present?
      @newspaper = Newspaper.find(params[:newspaper_id])
      @newspaper = NewspaperPresenter.new(current_user, NewspapersPolicy.new(@policy.agents.push(ObjectPolicyAgent.new(:Newspaper, @newspaper))), @newspaper)
      @policy.agents[-1], @policy.agents[-2] = @policy.agents[-2], @policy.agents[-1]
      @users = @newspaper.model.users.order(email: :asc)
      @users = UsersPresenter.new(current_user, @policy, @users)
      render "newspapers/users/index"
    else
      @users = User.order(email: :asc)
      @users = UsersPresenter.new(current_user, @policy, @users)
      render "users/index"
    end
  end

  def show
    @policy.authorize! :show?
    @user = UserPresenter.new(current_user, @policy, @user)
  end

  def new
    @policy.authorize! :new?
    @user = User.new
    @user = UserPresenter.new(current_user, @policy, @user)
  end

  def edit
    @policy.authorize! :edit?
    @user = UserPresenter.new(current_user, @policy, @user)
  end

  def create
    @policy.authorize! :create?
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html do
          @user = UserPresenter.new(current_user, @policy, @user)
          render :new
        end
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @policy.authorize! :update?
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html do
          @user = UserPresenter.new(current_user, @policy, @user)
          render :edit
        end
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

  def add
    if params[:publisher_id].present?
      publisher = Publisher.find(params[:publisher_id])
      publisher_policy = PublishersPolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Publisher, publisher)])
      publisher_policy.authorize! :add?
      publisher.users << @user
      respond_to do |format|
        format.html { redirect_to publisher_users_path(publisher), notice: 'User was successfully added..' }
        format.json { head :no_content }
      end
    elsif params[:newspaper_id].present?
      newspaper = Newspaper.find(params[:newspaper_id])
      newspaper_policy = NewspapersPolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Newspaper, newspaper)])
      newspaper_policy.authorize! :add?
      newspaper.users << @user
      respond_to do |format|
        format.html { redirect_to newspaper_users_path(newspaper), notice: 'User was successfully added..' }
        format.json { head :no_content }
      end
    end
  end

  def remove
    @policy.authorize! :remove?
    if params[:publisher_id].present?
      publisher = Publisher.find(params[:publisher_id])
      publisher_policy = PublishersPolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Publisher, publisher)])
      publisher_policy.authorize! :remove?, publisher
      publisher.users.delete(@user)
      respond_to do |format|
        format.html { redirect_to publisher_users_path(publisher), notice: 'User was successfully removed.' }
        format.json { head :no_content }
      end
    elsif params[:newspaper_id].present?
      newspaper = Newspaper.find(params[:newspaper_id])
      newspaper_policy = NewspapersPolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Newspaper, newspaper)])
      newspaper_policy.authorize! :remove?, newspaper
      newspaper.users.delete(@user)
      respond_to do |format|
        format.html { redirect_to newspaper_users_path(newspaper), notice: 'User was successfully added..' }
        format.json { head :no_content }
      end
    end
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
    @user = User.find(params[:id]) if params[:id].present?
    auto_login(@user)
    redirect_to root_path
  end

  def logout
    logout!
    redirect_to root_path
  end

  private
    # Authorization Policy
    def new_policy
      @user = User.find(params[:id]) if params[:id].present?
      UsersPolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:User, @user)])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:username, :display_name, :email)
    end
end

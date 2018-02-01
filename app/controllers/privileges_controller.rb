# frozen_string_literal: true

class PrivilegesController < ApplicationController
  def index
  end

  def permit
    if params[:newspaper_id].present?
      newspaper = Newspaper.find(params[:newspaper_id])
      user = User.find(params[:user_id])
      privilege = params[:id]
      respond_to do |format|
        if PolicyMaker.permit!(
          SubjectPolicyAgent.new(:User, user),
          RolePolicyAgent.new(:administrator), # privilege 1
          NewspaperPolicyAgent.new(newspaper)
        )
          format.html { redirect_to newspaper_path(newspaper), notice: 'Privilege was successfully permitted.' }
          format.json { head :no_content }
        else
          format.html { redirect_to newspaper_path(newspaper), notice: 'Privilege was NOT successfully permitted.' }
          format.json { head :no_content }
        end
      end
    elsif params[:publisher_id].present?
      publisher = Publisher.find(params[:publisher_id])
      user = User.find(params[:user_id])
      respond_to do |format|
        if PolicyMaker.permit!(
          SubjectPolicyAgent.new(:User, user),
          RolePolicyAgent.new(:administrator),
          PublisherPolicyAgent.new(publisher)
        )
          format.html { redirect_to publisher_path(publisher), notice: 'Privilege was successfully permitted.' }
          format.json { head :no_content }
        else
          format.html { redirect_to publisher_path(publisher), notice: 'Privilege was NOT successfully permitted.' }
          format.json { head :no_content }
        end
      end
    elsif params[:user_id].present?
      user = User.find(params[:user_id])
      respond_to do |format|
        if PolicyMaker.permit!(
          SubjectPolicyAgent.new(:User, user),
          RolePolicyAgent.new(:administrator),
          PolicyMaker::OBJECT_ANY
        )
          format.html { redirect_to users_path, notice: 'Privilege was successfully permitted.' }
          format.json { head :no_content }
        else
          format.html { redirect_to users_path, notice: 'Privilege was NOT successfully permitted.' }
          format.json { head :no_content }
        end
      end
    end
  end

  def revoke
    if params[:newspaper_id].present?
      newspaper = Newspaper.find(params[:newspaper_id])
      user = User.find(params[:user_id])
      respond_to do |format|
        if PolicyMaker.revoke!(
          SubjectPolicyAgent.new(:User, user),
          RolePolicyAgent.new(:administrator),
          NewspaperPolicyAgent.new(newspaper)
        )
          format.html { redirect_to newspaper_path(newspaper), notice: 'Privilege was successfully revoked.' }
          format.json { head :no_content }
        else
          format.html { redirect_to newspaper_path(newspaper), notice: 'Privilege was NOT successfully revoked.' }
          format.json { head :no_content }
        end
      end
    elsif params[:publisher_id].present?
      publisher = Publisher.find(params[:publisher_id])
      user = User.find(params[:user_id])
      respond_to do |format|
        if PolicyMaker.revoke!(
          SubjectPolicyAgent.new(:User, user),
          RolePolicyAgent.new(:administrator),
          PublisherPolicyAgent.new(publisher)
        )
          format.html { redirect_to publisher_path(publisher), notice: 'Privilege was successfully revoked.' }
          format.json { head :no_content }
        else
          format.html { redirect_to publisher_path(publisher), notice: 'Privilege was NOT successfully revoked.' }
          format.json { head :no_content }
        end
      end
    elsif params[:user_id].present?
      user = User.find(params[:user_id])
      respond_to do |format|
        if PolicyMaker.revoke!(
          SubjectPolicyAgent.new(:User, user),
          RolePolicyAgent.new(:administrator),
          PolicyMaker::OBJECT_ANY
        )
          format.html { redirect_to users_path, notice: 'Privilege was successfully revoked.' }
          format.json { head :no_content }
        else
          format.html { redirect_to users_path, notice: 'Privilege was NOT successfully revoked.' }
          format.json { head :no_content }
        end
      end
    end
  end

  private
    # Authorization Policy
    def new_policy
      @privilege = Privilege.new(id: params[:id], requestor: current_user)
      PrivilegesPolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Privilege, @privilege)])
    end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def privilege_params
  #   params.require(:privilege).permit(:subject_type, :subject_id, :verb_type, :verb_id, :object_type, :object_id)
  # end
end

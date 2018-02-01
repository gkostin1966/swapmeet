# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  # it_should_behave_like 'policy enforcer', :user, :User

  describe '#new_policy' do
    it { expect(subject.send(:new_policy)).to be_a(UsersPolicy) }
  end

  context 'actions' do
    let(:current_user) { create(:user) }
    let(:user) { create(:user) }
    let(:group) { create(:group) }
    let(:newspaper) { create(:newspaper) }
    let(:publisher) { create(:publisher) }

    before do
      allow(controller).to receive(:current_user).and_return(current_user)
      allow(UsersPolicy).to receive(:new).and_return(policy)
    end

    context 'unauthorized' do
      let(:policy) { ControllersHelper::UnauthorizePolicy.new([SubjectPolicyAgent.new(:User, current_user), UserPolicyAgent.new(user)]) }

      it '#index' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end

      it '#show' do
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:unauthorized)
      end

      it '#new' do
        get :new
        expect(response).to have_http_status(:unauthorized)
      end

      it '#edit' do
        get :edit, params: { id: user.id }
        expect(response).to have_http_status(:unauthorized)
      end

      it '#create' do
        post :create, params: { user: {} }
        expect(response).to have_http_status(:unauthorized)
      end

      it '#update' do
        post :update, params: { id: user.id, user: {} }
        expect(response).to have_http_status(:unauthorized)
      end

      it '#destroy' do
        delete :destroy, params: { id: user.id }
        expect(response).to have_http_status(:unauthorized)
      end

      describe '#index' do
        before { allow(PolicyMaker).to receive(:permit!).and_return(boolean) }
        context 'group' do
          before { get :index, params: { group_id: group.id, id: user.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
        context 'newspaper' do
          before { get :index, params: { newspaper_id: newspaper.id, id: user.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
        context 'publisher' do
          before { get :index, params: { publisher_id: publisher.id, id: user.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
      end

      describe '#add' do
        # context 'group' do
        #   before { patch :add, params: { group_id: group.id, id: user.id } }
        #   it { expect(response).to have_http_status(:unauthorized) }
        # end
        context 'newspaper' do
          before { patch :add, params: { newspaper_id: newspaper.id, id: user.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
        context 'publisher' do
          before { patch :add, params: { publisher_id: publisher.id, id: user.id  } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
      end

      describe '#remove' do
        # context 'group' do
        #   before { delete :remove, params: { group_id: group.id, id: user.id } }
        #   it { expect(response).to have_http_status(:unauthorized) }
        # end
        context 'newspaper' do
          before { delete :remove, params: { newspaper_id: newspaper.id, id: user.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
        context 'publisher' do
          before { delete :remove, params: { publisher_id: publisher.id, id: user.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
      end

      describe '#join' do
        context 'group' do
          before { patch :join, params: { group_id: group.id, id: user.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
      end

      describe '#leave' do
        context 'group' do
          before { delete :leave, params: { group_id: group.id, id: user.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
      end
    end

    context 'authorized' do
      let(:policy) { ControllersHelper::AuthorizePolicy.new([SubjectPolicyAgent.new(:User, current_user), UserPolicyAgent.new(user)]) }
      it '#index' do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it '#show' do
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:ok)
      end

      it '#new' do
        get :new
        expect(response).to have_http_status(:ok)
      end

      it '#edit' do
        get :edit, params: { id: user.id }
        expect(response).to have_http_status(:ok)
      end

      describe '#create' do
        before do
          allow(User).to receive(:new).and_return(user)
          allow(user).to receive(:save).and_return(boolean)
          post :create, params: { user: { username: user.username, display_name: user.display_name, parent_id: nil } }
        end
        context 'success' do
          let(:boolean) { true }
          it do
            expect(response).to redirect_to(user)
            expect(response).to have_http_status(:found)
          end
        end
        context 'fail' do
          let(:boolean) { false }
          it do
            expect(response).not_to redirect_to(user)
            expect(response).to have_http_status(:ok)
          end
        end
      end

      describe '#update' do
        before do
          allow(User).to receive(:find).with(user.id.to_s).and_return(user)
          allow(user).to receive(:update).and_return(boolean)
          post :update, params: { id: user.id, user: { username: user.username, display_name: user.display_name, parent_id: nil } }
        end
        context 'success' do
          let(:boolean) { true }
          it do
            expect(response).to redirect_to(user)
            expect(response).to have_http_status(:found)
          end
        end
        context 'fail' do
          let(:boolean) { false }
          it do
            expect(response).not_to redirect_to(user)
            expect(response).to have_http_status(:ok)
          end
        end
      end

      it '#destroy' do
        delete :destroy, params: { id: user.id }
        expect(response).to have_http_status(:found)
      end

      describe '#index' do
        before { allow(PolicyMaker).to receive(:permit!).and_return(boolean) }
        context 'group' do
          before { get :index, params: { group_id: group.id, id: user.id } }
          it { expect(response).to have_http_status(:ok) }
        end
        context 'newspaper' do
          before { get :index, params: { newspaper_id: newspaper.id, id: user.id } }
          it { expect(response).to have_http_status(:ok) }
        end
        context 'publisher' do
          before { get :index, params: { publisher_id: publisher.id, id: user.id } }
          it { expect(response).to have_http_status(:ok) }
        end
      end

      describe '#add' do
        before { allow(PolicyMaker).to receive(:permit!).and_return(boolean) }
        # context 'group' do
        #   before { patch :add, params: { group_id: group.id, id: user.id } }
        #   it { expect(response).to have_http_status(:found) }
        # end
        context 'newspaper' do
          let(:newspapers_policy) { ControllersHelper::AuthorizePolicy.new([SubjectPolicyAgent.new(:User, current_user), NewspaperPolicyAgent.new(newspaper)]) }
          before do
            allow(NewspapersPolicy).to receive(:new).and_return(newspapers_policy)
            patch :add, params: { newspaper_id: newspaper.id, id: user.id }
          end
          it { expect(response).to have_http_status(:found) }
        end
        context 'publisher' do
          let(:publishers_policy) { ControllersHelper::AuthorizePolicy.new([SubjectPolicyAgent.new(:User, current_user), PublisherPolicyAgent.new(publisher)]) }
          before do
            allow(PublishersPolicy).to receive(:new).and_return(publishers_policy)
            patch :add, params: { publisher_id: publisher.id, id: user.id  }
          end
          it { expect(response).to have_http_status(:found) }
        end
      end

      describe '#remove' do
        before { allow(PolicyMaker).to receive(:permit!).and_return(boolean) }
        # context 'group' do
        #   before { delete :remove, params: { group_id: group.id, id: user.id } }
        #   it { expect(response).to have_http_status(:found) }
        # end
        context 'newspaper' do
          let(:newspapers_policy) { ControllersHelper::AuthorizePolicy.new([SubjectPolicyAgent.new(:User, current_user), NewspaperPolicyAgent.new(newspaper)]) }
          before do
            allow(NewspapersPolicy).to receive(:new).and_return(newspapers_policy)
            delete :remove, params: { newspaper_id: newspaper.id, id: user.id }
          end
          it { expect(response).to have_http_status(:found) }
        end
        context 'publisher' do
          let(:publishers_policy) { ControllersHelper::AuthorizePolicy.new([SubjectPolicyAgent.new(:User, current_user), PublisherPolicyAgent.new(publisher)]) }
          before do
            allow(PublishersPolicy).to receive(:new).and_return(publishers_policy)
            delete :remove, params: { publisher_id: publisher.id, id: user.id }
          end
          it { expect(response).to have_http_status(:found) }
        end
      end

      describe '#join' do
        context 'group' do
          before { patch :join, params: { group_id: group.id, id: user.id } }
          it { expect(response).to have_http_status(:found) }
        end
      end

      describe '#leave' do
        context 'group' do
          before { delete :leave, params: { group_id: group.id, id: user.id } }
          it { expect(response).to have_http_status(:found) }
        end
      end
    end
  end

  context 'authenticate' do
    describe '#login' do
      subject { post :login, params: { id: user.id } }
      let(:user) { build(:user, id: 1) }
      before do
        allow(User).to receive(:find).with('1').and_return(user)
        subject
      end
      it 'signs in' do
        expect(session[:user_id]).to be user.id
        expect(response).to redirect_to root_path
      end
    end

    describe '#logout' do
      subject { post :logout }
      let(:user) { build(:user, id: 1) }
      before do
        allow(User).to receive(:find).with('1').and_return(user)
        post :login, params: { id: user.id }
        subject
      end
      it 'signs off' do
        expect(session[:user_id]).to be nil
        expect(response).to redirect_to root_path
      end
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  describe '#new_policy' do
    it { expect(subject.send(:new_policy)).to be_a(GroupsPolicy) }
  end

  context 'actions' do
    let(:current_user) { create(:user) }
    let(:group) { create(:group) }
    let(:newspaper) { create(:newspaper) }
    let(:publisher) { create(:publisher) }

    before do
      allow(controller).to receive(:current_user).and_return(current_user)
      allow(GroupsPolicy).to receive(:new).and_return(policy)
    end

    context 'unauthorized' do
      let(:policy) { ControllersHelper::UnauthorizePolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Group, group)]) }

      it '#index' do
        get :index
        expect(response).to have_http_status(:unauthorized)
      end

      it '#show' do
        get :show, params: { id: group.id }
        expect(response).to have_http_status(:unauthorized)
      end

      it '#new' do
        get :new
        expect(response).to have_http_status(:unauthorized)
      end

      it '#edit' do
        get :edit, params: { id: group.id }
        expect(response).to have_http_status(:unauthorized)
      end

      it '#create' do
        post :create, params: { group: {} }
        expect(response).to have_http_status(:unauthorized)
      end

      it '#update' do
        post :update, params: { id: group.id, group: {} }
        expect(response).to have_http_status(:unauthorized)
      end

      it '#destroy' do
        delete :destroy, params: { id: group.id }
        expect(response).to have_http_status(:unauthorized)
      end

      describe '#index' do
        before { allow(PolicyMaker).to receive(:permit!).and_return(boolean) }
        context 'group' do
          before { get :index, params: { group_id: group.id, id: group.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
        context 'newspaper' do
          before { get :index, params: { newspaper_id: newspaper.id, id: group.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
        context 'publisher' do
          before { get :index, params: { publisher_id: publisher.id, id: group.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
      end

      describe '#add' do
        context 'group' do
          before { patch :add, params: { group_id: group.id, id: group.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
        context 'newspaper' do
          before { patch :add, params: { newspaper_id: newspaper.id, id: group.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
        context 'publisher' do
          before { patch :add, params: { publisher_id: publisher.id, id: group.id  } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
      end

      describe '#remove' do
        context 'group' do
          before { delete :remove, params: { group_id: group.id, id: group.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
        context 'newspaper' do
          before { delete :remove, params: { newspaper_id: newspaper.id, id: group.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
        context 'publisher' do
          before { delete :remove, params: { publisher_id: publisher.id, id: group.id } }
          it { expect(response).to have_http_status(:unauthorized) }
        end
      end
    end

    context 'authorized' do
      let(:policy) { ControllersHelper::AuthorizePolicy.new([SubjectPolicyAgent.new(:User, current_user), ObjectPolicyAgent.new(:Group, group)]) }
      it '#index' do
        get :index
        expect(response).to have_http_status(:ok)
      end

      it '#show' do
        get :show, params: { id: group.id }
        expect(response).to have_http_status(:ok)
      end

      it '#new' do
        get :new
        expect(response).to have_http_status(:ok)
      end

      it '#edit' do
        get :edit, params: { id: group.id }
        expect(response).to have_http_status(:ok)
      end

      describe '#create' do
        before do
          allow(Group).to receive(:new).and_return(group)
          allow(group).to receive(:save).and_return(boolean)
          post :create, params: { group: { name: group.name, display_name: group.display_name, parent_id: nil } }
        end
        context 'success' do
          let(:boolean) { true }
          it do
            expect(response).to redirect_to(group)
            expect(response).to have_http_status(:found)
          end
        end
        context 'fail' do
          let(:boolean) { false }
          it do
            expect(response).not_to redirect_to(group)
            expect(response).to have_http_status(:ok)
          end
        end
      end

      describe '#update' do
        before do
          allow(Group).to receive(:find).with(group.id.to_s).and_return(group)
          allow(group).to receive(:update).and_return(boolean)
          post :update, params: { id: group.id, group: { name: group.name, display_name: group.display_name, parent_id: nil } }
        end
        context 'success' do
          let(:boolean) { true }
          it do
            expect(response).to redirect_to(group)
            expect(response).to have_http_status(:found)
          end
        end
        context 'fail' do
          let(:boolean) { false }
          it do
            expect(response).not_to redirect_to(group)
            expect(response).to have_http_status(:ok)
          end
        end
      end

      it '#destroy' do
        delete :destroy, params: { id: group.id }
        expect(response).to have_http_status(:found)
      end

      describe '#index' do
        before { allow(PolicyMaker).to receive(:permit!).and_return(boolean) }
        context 'group' do
          before { get :index, params: { group_id: group.id, id: group.id } }
          it { expect(response).to have_http_status(:ok) }
        end
        context 'newspaper' do
          before { get :index, params: { newspaper_id: newspaper.id, id: group.id } }
          it { expect(response).to have_http_status(:ok) }
        end
        context 'publisher' do
          before { get :index, params: { publisher_id: publisher.id, id: group.id } }
          it { expect(response).to have_http_status(:ok) }
        end
      end

      describe '#add' do
        before { allow(PolicyMaker).to receive(:permit!).and_return(boolean) }
        context 'group' do
          before { patch :add, params: { group_id: group.id, id: group.id } }
          it { expect(response).to have_http_status(:found) }
        end
        context 'newspaper' do
          before { patch :add, params: { newspaper_id: newspaper.id, id: group.id } }
          it { expect(response).to have_http_status(:found) }
        end
        context 'publisher' do
          before { patch :add, params: { publisher_id: publisher.id, id: group.id  } }
          it { expect(response).to have_http_status(:found) }
        end
      end

      describe '#remove' do
        before { allow(PolicyMaker).to receive(:permit!).and_return(boolean) }
        context 'group' do
          before { delete :remove, params: { group_id: group.id, id: group.id } }
          it { expect(response).to have_http_status(:found) }
        end
        context 'newspaper' do
          before { delete :remove, params: { newspaper_id: newspaper.id, id: group.id } }
          it { expect(response).to have_http_status(:found) }
        end
        context 'publisher' do
          before { delete :remove, params: { publisher_id: publisher.id, id: group.id } }
          it { expect(response).to have_http_status(:found) }
        end
      end
    end
  end
end

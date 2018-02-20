# frozen_string_literal: true

module ControllersHelper
  class AuthorizePolicy < ApplicationPolicy
    def method_missing(method_name, *args, &block)
      return true if method_name[-1] == '?'
      super
    end
    def authorize!(action, message = nil); end
  end
  class UnauthorizePolicy < ApplicationPolicy
    def authorize!(action, message = nil); raise NotAuthorizedError.new(message); end
  end
end

#
# Policy Enforcement
#
RSpec.shared_examples 'policy enforcer' do |model, klass, attrs = nil |
  describe "#{model} unautorized" do
    controller do
      def set_policy
        @policy = ControllersHelper::UnauthorizePolicy.new([nil, nil])
      end
    end

    before do
      attrs ||= attributes_for(model)
      allow(klass.to_s.classify.constantize).to receive(:find).with('1').and_return(nil)
    end

    it '#index' do
      get :index
      expect(response).to be_unauthorized
    end

    it '#show' do
      get :show, params: { id: '1' }
      expect(response).to be_unauthorized
    end

    it '#new' do
      get :new
      expect(response).to be_unauthorized
    end

    it '#edit' do
      get :edit, params: { id: '1' }
      expect(response).to be_unauthorized
    end

    it '#create' do
      post :create, params: { model => attrs }
      expect(response).to be_unauthorized
    end

    it '#update' do
      post :update, params: { id: '1', model => attrs }
      expect(response).to be_unauthorized
    end

    it '#destroy' do
      delete :destroy, params: { id: '1' }
      expect(response).to be_unauthorized
    end
  end

  describe "#{model} authorized" do
    let(:target) { build(model, id: 1) }

    controller do
      def set_policy
        @policy = ControllersHelper::AuthorizePolicy.new([nil, nil])
      end
    end

    before do
      controller.instance_variable_set("@#{model}", target)
      allow(klass.to_s.classify.constantize).to receive(:find).with('1').and_return(target)
    end

    it '#index' do
      get :index
      expect(response).to be_success
    end

    it '#show' do
      get :show, params: { id: '1' }
      expect(response).to be_success
    end

    it '#new' do
      get :new
      expect(response).to be_success
    end

    it '#edit' do
      get :edit, params: { id: '1' }
      expect(response).to be_success
    end

    describe '#create' do
      before do
        allow(klass.to_s.classify.constantize).to receive(:new).and_return(target)
        allow(target).to receive(:save).and_return(boolean)
        post :create, params: { model => attrs }
      end
      context 'success' do
        let(:boolean) { true }
        it do
          expect(response).to redirect_to(controller.instance_variable_get("@#{model}"))
          expect(response).to have_http_status(:found)
        end
      end
      context 'fail' do
        let(:boolean) { false }
        it do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe '#update' do
      before do
        allow(target).to receive(:update).and_return(boolean)
        post :update, params: { id: '1', model => attrs }
      end
      context 'success' do
        let(:boolean) { true }
        it do
          expect(response).to redirect_to(controller.instance_variable_get("@#{model}"))
          expect(response).to have_http_status(:found)
        end
      end
      context 'fail' do
        let(:boolean) { false }
        it do
          expect(response).to have_http_status(:ok)
        end
      end
    end

    it '#destroy' do
      delete :destroy, params: { id: '1' }
      expect(response).to have_http_status(:found)
    end
  end
end

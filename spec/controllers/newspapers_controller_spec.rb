# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewspapersController, type: :controller do
  let(:user) { build(:user, id: 1) }
  let(:newspaper) { build(:newspaper, id: 2) }
  let(:publisher) { build(:publisher, id: 3) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(Newspaper).to receive(:find).with(newspaper.id.to_s).and_return(newspaper)
    allow(Publisher).to receive(:find).with(publisher.id.to_s).and_return(publisher)
  end

  context 'policy enforcement' do
    it_should_behave_like 'policy enforcer', :newspaper, :Newspaper, "name": "Name", "display_name": "Display Name", "publisher_id": "3"
  end

  describe '#new_policy' do
    it { expect(subject.send(:new_policy)).to be_a(NewspapersPolicy) }
  end

  context 'actions' do
    describe '#index' do
      it do
        get :index
        expect(response).to have_http_status(:ok)
      end
      context 'publisher' do
        it do
          get :index, params: { publisher_id: publisher.id }
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe '#show' do
      it do
        get :show, params: { id: newspaper.id }
        expect(response).to have_http_status(:ok)
      end
      context 'publisher' do
        it do
          get :show, params: { publisher_id: publisher.id, id: newspaper.id }
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe '#add' do
      context 'publisher' do
        it do
          patch :add, params: { publisher_id: publisher.id, id: newspaper.id }
          expect(response).to have_http_status(:found)
        end
      end
    end

    describe '#remove' do
      context 'publisher' do
        it do
          delete :remove, params: { publisher_id: publisher.id, id: newspaper.id }
          expect(response).to have_http_status(:found)
        end
      end
    end
  end
end

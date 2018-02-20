# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ListingsController, type: :controller do
  let(:user) { create(:user, id: 1) }
  let(:category) { create(:category, id: 2) }
  let(:newspaper) { create(:newspaper, id: 3) }

  before do
    allow(controller).to receive(:current_user).and_return(user)
    allow(Category).to receive(:find).with(category.id.to_s).and_return(category)
    allow(Newspaper).to receive(:find).with(newspaper.id.to_s).and_return(newspaper)
  end

  context 'policy enforcement' do
    it_should_behave_like 'policy enforcer', :listing, :Listing, "body": "body", "category_id": "2", "title": "title", "newspaper_id": "3"
  end

  describe '#new_policy' do
    it { expect(subject.send(:new_policy)).to be_a(ListingsPolicy) }
  end

  context 'actions' do
    describe '#index' do
      it do
        get :index, params: { f: { category: 'category', newspaper: 'newspaper', owner: 'owner' } }
        expect(response).to have_http_status(:ok)
      end
      context 'category' do
        it do
          get :index, params: { category_id: category.id }
          expect(response).to have_http_status(:ok)
        end
      end
    end
  end
end

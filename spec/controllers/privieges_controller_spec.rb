# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PrivilegesController, type: :controller do
  it { is_expected.to be_a(PrivilegesController) }

  describe '#new_policy' do
    it { expect(subject.send(:new_policy)).to be_a(PrivilegesPolicy) }
  end

  context 'actions' do
    let(:privilege) { build(:privilege, id: 1) }
    let(:user) { build(:user, id: 2) }
    let(:newspaper) { build(:newspaper, id: 3) }
    let(:publisher) { build(:publisher, id: 4) }

    before do
      allow(User).to receive(:find).with(user.id.to_s).and_return(user)
      allow(Newspaper).to receive(:find).with(newspaper.id.to_s).and_return(newspaper)
      allow(Publisher).to receive(:find).with(publisher.id.to_s).and_return(publisher)
    end

    describe '#permit' do
      before { allow(PolicyMaker).to receive(:permit!).and_return(boolean) }
      context 'user' do
        before { patch :permit, params: { user_id: user.id, id: privilege.id } }
        context 'success' do
          let(:boolean) { true }
          it { expect(response).to have_http_status(:found) }
        end
        context 'fail' do
          let(:boolean) { false }
          it { expect(response).to have_http_status(:found) }
        end
      end
      context 'newspaper' do
        before { patch :permit, params: { newspaper_id: newspaper.id, user_id: user.id, id: privilege.id } }
        context 'success' do
          let(:boolean) { true }
          it { expect(response).to have_http_status(:found) }
        end
        context 'fail' do
          let(:boolean) { false }
          it { expect(response).to have_http_status(:found) }
        end
      end
      context 'publisher' do
        before { patch :permit, params: { publisher_id: publisher.id, user_id: user.id, id: privilege.id } }
        context 'success' do
          let(:boolean) { true }
          it { expect(response).to have_http_status(:found) }
        end
        context 'fail' do
          let(:boolean) { false }
          it { expect(response).to have_http_status(:found) }
        end
      end
    end

    describe '#revoke' do
      before { allow(PolicyMaker).to receive(:revoke!).and_return(boolean) }
      context 'user' do
        before { delete :revoke, params: { user_id: user.id, id: privilege.id } }
        context 'success' do
          let(:boolean) { true }
          it { expect(response).to have_http_status(:found) }
        end
        context 'fail' do
          let(:boolean) { false }
          it { expect(response).to have_http_status(:found) }
        end
      end
      context 'newspaper' do
        before { delete :revoke, params: { newspaper_id: newspaper.id, user_id: user.id, id: privilege.id } }
        context 'success' do
          let(:boolean) { true }
          it { expect(response).to have_http_status(:found) }
        end
        context 'fail' do
          let(:boolean) { false }
          it { expect(response).to have_http_status(:found) }
        end
      end
      context 'publisher' do
        before { delete :revoke, params: { publisher_id: publisher.id, user_id: user.id, id: privilege.id } }
        context 'success' do
          let(:boolean) { true }
          it { expect(response).to have_http_status(:found) }
        end
        context 'fail' do
          let(:boolean) { false }
          it { expect(response).to have_http_status(:found) }
        end
      end
    end
  end
end

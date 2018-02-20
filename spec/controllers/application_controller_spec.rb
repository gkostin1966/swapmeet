# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  context 'rescue_from exception' do
    controller do
      attr_accessor :the_exception
      def trigger
        raise @the_exception
      end
    end
    before do
      routes.draw { get "trigger" => "anonymous#trigger" }
    end
    it "responds with unauthorized on NotAuthorizedError" do
      controller.the_exception = NotAuthorizedError.new
      expect { get :trigger }.not_to raise_error
      expect(response).to be_unauthorized
    end
  end

  context "current user" do
    let(:user) { create(:user) }
    it do
      expect(subject.send(:logged_in?)).to be false
      expect(subject.send(:current_user).id).to eq User.guest.id
      expect(subject.send(:auto_login, user)).to be user.id
      expect(subject.send(:logged_in?)).to be true
      expect(subject.send(:current_user).id).to eq user.id
      expect(subject.send(:logout!)).to be nil
      expect(subject.send(:logged_in?)).to be false
      expect(subject.send(:current_user).id).to eq User.guest.id
    end
  end

  context '#set_policy' do
    let(:policy) { double('policy') }
    before do
      allow(ApplicationPolicy).to receive(:new).and_return(policy)
    end
    it do
      subject.send(:set_policy)
      expect(subject.instance_variable_get(:@policy)).to be policy
    end
    context 'authenticated' do
      let(:user) { create(:user) }
      it do
        subject.send(:auto_login, user)
        subject.send(:set_policy)
        expect(subject.instance_variable_get(:@policy)).to be policy
      end
    end
  end

  describe '#new_policy' do
    it { expect(subject.send(:new_policy)).to be_a(ApplicationPolicy) }
  end
end

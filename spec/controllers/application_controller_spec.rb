# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationController do
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
end

require 'rails_helper'
require 'jwt'

RSpec.describe ApplicationController, type: :controller do
  controller do
    skip_before_action :require_authentication
    
    def test_current_user
      render plain: current_user || 'no user'
    end
  end

  before do
    routes.draw do
      get 'test_current_user' => 'anonymous#test_current_user'
    end
  end

  describe '#current_user' do
    context 'when there is no valid token' do
      it 'returns nil' do
        get :test_current_user
        expect(response.body).to eq('no user')
      end
    end

    context 'when there is a valid token' do
      it 'returns the sub claim from the token' do
        setup_authenticated_header('user123')
        get :test_current_user
        expect(response.body).to eq('user123')
      end
    end

    context 'when the token is invalid' do
      it 'returns nil' do
        request.headers['Authorization'] = "Bearer invalid.token.here"
        get :test_current_user
        expect(response.body).to eq('no user')
      end
    end
  end
end

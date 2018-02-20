# frozen_string_literal: true

Rails.application.routes.draw do
  resources :categories do
    resources :listings, only: [:index] do
    end
  end

  resources :gatekeepers

  resources :groups do
    resources :groups, only: [:index] do
      member do
        patch :add
        delete :remove
      end
    end
    resources :users, only: [:index] do
      member do
        patch :join
        delete :leave
      end
    end
    resources :publishers, only: [:index] do
      member do
        patch :add
        delete :remove
      end
    end
  end

  resources :domains do
    resources :domains
    resources :publishers
  end

  resources :listings

  resources :newspapers do
    resources :listings
    resources :groups, only: [:index] do
      member do
        patch :add
        delete :remove
      end
    end
    resources :users, only: [:index] do
      resources :privileges, only: [:index] do
        member do
          patch :permit
          delete :revoke
        end
      end
      member do
        patch :add
        delete :remove
      end
    end
  end

  resources :publishers do
    resources :newspapers, only: [:index, :show] do
      resources :users, only: [:index] do
        member do
          patch :add
          delete :remove
        end
      end
      member do
        patch :add
        delete :remove
      end
    end
    resources :groups, only: [:index] do
      member do
        patch :add
        delete :remove
      end
    end
    resources :users, only: [:index] do
      resources :privileges, only: [:index] do
        member do
          patch :permit
          delete :revoke
        end
      end
      member do
        patch :add
        delete :remove
      end
    end
  end

  resources :users do
    resources :privileges, only: [:index] do
      member do
        patch :permit
        delete :revoke
      end
    end
    resources :groups, only: [:index] do
      member do
        patch :join
        delete :leave
      end
    end
    resources :listings, only: [:index] do
      member do
        patch :add
        delete :remove
      end
    end
    resources :newspapers, only: [:index] do
      member do
        patch :join
        delete :leave
      end
    end
    resources :publishers, only: [:index] do
      member do
        patch :join
        delete :leave
      end
    end
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'listings#index'

  match '/login/:id', to: 'users#login', as: :login, via: [:get, :post]
  match '/logout', to: 'users#logout', as: :logout, via: [:get, :post]
end

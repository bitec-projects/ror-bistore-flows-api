require "sidekiq/web"

Rails.application.routes.draw do
  # Adicione esse bloco só ao redor do mount Sidekiq::Web:
  if Rails.env.development? || Rails.env.test?
    # Middleware para sessão/cookies só para o painel Sidekiq local
    Sidekiq::Web.use ActionDispatch::Cookies
    Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_session_id"
    mount Sidekiq::Web => "/sidekiq"
  end

  # ... suas demais rotas
  namespace :api do
    namespace :v1 do
      post "webhooks/evolution", to: "webhooks#evolution"
    end
  end
end

require "sidekiq/web"

Rails.application.routes.draw do
  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |user, password|
      # Use um usuário/senha forte só para a produção!
      ActiveSupport::SecurityUtils.secure_compare(user, "bitec_admin") &
      ActiveSupport::SecurityUtils.secure_compare(password, "Bitec@2024#Admin2025")
    end
  end

  # Middleware para sessão/cookies só para o painel Sidekiq local
  Sidekiq::Web.use ActionDispatch::Cookies
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_session_id"
  mount Sidekiq::Web => "/sidekiq"

  # ... suas demais rotas
  namespace :api do
    namespace :v1 do
      post "webhooks/evolution", to: "webhooks#evolution"
    end
  end
end

namespace :api do
  namespace :v1 do
    post "webhooks/evolution", to: "webhooks#evolution"
  end
end

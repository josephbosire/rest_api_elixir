defmodule RealDealApiWeb.Router do
  use RealDealApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug RealDealApiWeb.Auth.Pipeline
    plug RealDealApiWeb.Auth.Plugs.SetAccount
  end

  scope "/api", RealDealApiWeb do
    pipe_through :api

    get "/hello", DefaultController, :index
    post "/accounts/create", AccountController, :create
    post "/accounts/sign_in", AccountController, :sign_in
  end

  # Protected Endpoints
  scope "/api", RealDealApiWeb do
    pipe_through [:api, :auth]

    get "/accounts/:id/sign_out", AccountController, :sign_out

    get "/accounts/refresh_session", AccountController, :refresh_session

    resources "/accounts", AccountController, only: [:show, :index, :update]
  end
end

defmodule GiveawayWeb.Router do
  use GiveawayWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug Phoenix.LiveView.Flash
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GiveawayWeb do
    pipe_through :browser

    get "/", PageController, :index

    live "/giveaway", GiveawayLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", GiveawayWeb do
  #   pipe_through :api
  # end
end

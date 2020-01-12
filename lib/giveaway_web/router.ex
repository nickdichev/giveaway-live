defmodule GiveawayWeb.Router do
  use GiveawayWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GiveawayWeb do
    pipe_through :browser

    live "/", GiveawayLive
    live "/room/:room_name", RoomLive
    live "/room/:room_name/admin", RoomAdminLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", GiveawayWeb do
  #   pipe_through :api
  # end
end

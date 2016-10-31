defmodule Sleepwatching.Router do
  use Sleepwatching.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Sleepwatching do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/renderers", PageController, :renderers
    get "/confirm/:id", PageController, :confirm
    get "/confirmed/:id", PageController, :confirmed
    get "/turn_off/:uuid", PageController, :turn_off
    post "/sleepiq/:id", PageController, :sleepiq
  end

  # Other scopes may use custom stacks.
  # scope "/api", Sleepwatching do
  #   pipe_through :api
  # end
end

defmodule GroupCollectWeb.Router do
  use GroupCollectWeb, :router

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

  scope "/", GroupCollectWeb do
    pipe_through :browser

    # get "/", PageController, :index
    get "/", ReportController, :index
    get "/passenger/:id", ReportController, :show
    get "/insert_csv", Report.ImportController, :new
    post "/insert_csv", Report.ImportController, :post
    get "/message", Report.MessageController, :new
    post "/message", Report.MessageController, :create
    get "/graphs/package", Report.ChartController, :package
  end

  # Other scopes may use custom stacks.
  # scope "/api", GroupCollectWeb do
  #   pipe_through :api
  # end
end

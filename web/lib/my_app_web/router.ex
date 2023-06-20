defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  ### Shopifex Routing
  require ShopifexWeb.Routes
  ShopifexWeb.Routes.pipelines()

  # Include all auth (when Shopify requests to render your app in an iframe), installation and update routes
  ShopifexWeb.Routes.auth_routes(MyAppWeb.ShopifyAuthController)

  # Include all payment routes
  ShopifexWeb.Routes.payment_routes(MyAppWeb.ShopifyPaymentController)

  # Endpoints accessible within the Shopify admin panel iFrame.
  # Don't include this scope block if you are creating a SPA.
  scope "/", MyAppWeb do
    pipe_through [:shopifex_browser, :shopify_session]

    get "/", PageController, :index
  end

  ### End of Shopifex Routing ###

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {MyAppWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MyAppWeb do
    pipe_through [:api, :shopify_session]
    get "/products/count", ProductsController, :count
    get "/products/create", ProductsController, :create
  end

  scope "/webhooks", MyAppWeb do
    pipe_through [:shopify_webhook]
    post "/shopify", ShopifyWebhookController, :action
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:my_app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MyAppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

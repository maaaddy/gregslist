defmodule GregslistWeb.Router do
  use GregslistWeb, :router

  import GregslistWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GregslistWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GregslistWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/gregslist", PageController, :gregslist
    get "/photo/:id", PageController, :photo
    get "/categories", PageController, :categories
    get "/items/:id/detail", ItemController, :detail
    get "/items/:id/details", ItemController, :details

    post "/listingphoto", ImageApi, :add_image
    post "/profilephoto", ImageApi, :add_profile_image

    resources "/items", ItemController
    live "/new", ItemLive.Index, :new
    live "/detail", ItemController, :detail
    live "/details", ItemController, :details
    live "/items/:id/edit", ItemLive.Index, :edit
    live "/items/:id", ItemLive.Show, :show
    live "/items/:id/show/edit", ItemLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", GregslistWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:gregslist, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: GregslistWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", GregslistWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/items/:id/mydetail", ItemController, :mydetail

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{GregslistWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", GregslistWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{GregslistWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
      live "/chat", ChatLive.Index, :index
      live "/myitems", ItemLive.Myitems
      live "/business", ItemLive.Business
      live "/furniture", ItemLive.Furniture
    live "/clothes", ItemLive.Clothes
    live "/technology", ItemLive.Technology
    live "/vehicles", ItemLive.Vehicles
    live "/other", ItemLive.Other
      live "/search", SearchLive
      live "/users", UserListLive.Index, :index
      live "/user_chat/:recipient_id", UserChatLive.Index, :index
      live "/users/profile", UserProfileLive.Index, :index
      live "/messages", MessagesLive.Index, :index

    end
  end

  scope "/", GregslistWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{GregslistWeb.UserAuth, :mount_current_user}] do
        live "/myitems", ItemLive.Myitems
        live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end

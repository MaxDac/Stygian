defmodule StygianWeb.Router do
  use StygianWeb, :router

  import StygianWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {StygianWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :browser_internal do
    plug :browser
    plug :fetch_character
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", StygianWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:stygian_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: StygianWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Home routes

  scope "/map", StygianWeb.ChatLive do
    pipe_through [:browser_internal, :require_user_authenticated_and_character]

    live_session :private_chat_live,
      on_mount: [{StygianWeb.UserAuth, :ensure_authenticated_and_mount_character}] do
      live "/private", PrivateRoomsLive, :index
      live "/private/book/:map_id", BookPrivateRoomLive, :index
    end
  end

  scope "/", StygianWeb.ChatLive do
    pipe_through [:browser, :require_authenticated_user]

    live_session :chat_live,
      on_mount: [{StygianWeb.UserAuth, :ensure_authenticated_and_mount_character}] do
      live "/", MainMapLive, :index
      live "/map/:map_id", MapLive, :show
      live "/chat/:map_id", ChatLive, :index
      live "/online", OnlineLive, :index
    end
  end

  ## Authentication routes

  scope "/", StygianWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{StygianWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", StygianWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{StygianWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", StygianWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{StygianWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end

  scope "/character", StygianWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/redirect", CharacterController, :handle_create
    get "/redirect/:character_id", CharacterController, :handle_create
    get "/rest", CharacterController, :handle_rest
  end

  scope "/character", StygianWeb.CharacterLive do
    pipe_through [:browser, :require_authenticated_user]

    live_session :character_creation,
      on_mount: [{StygianWeb.UserAuth, :ensure_authenticated}] do
      live "/create", CharacterCreationLive, :create
      live "/complete", CharacterCompletionLive, :complete
    end

    live_session :character_sheet,
      on_mount: [{StygianWeb.UserAuth, :ensure_authenticated_and_mount_character}] do
      live "/sheet/modify", CharacterSheetUpdateLive, :edit
      live "/sheet", CharacterSheetLive, :index
      live "/stats", CharacterSheetStatsLive, :index
    end

    live_session :characters_list,
      on_mount: [{StygianWeb.UserAuth, :ensure_authenticated}] do
      live "/sheets", CharacterListLive
      live "/sheet/:character_id", CharacterSheetLive, :show
      live "/custom_sheet/:character_id", CharacterCustomSheetLive, :index
    end

    live_session :characters_external_info,
      on_mount: [{StygianWeb.UserAuth, :ensure_admin_or_character}] do
      live "/stats/:character_id", CharacterSheetStatsLive, :show
    end
  end

  scope "/", StygianWeb.TransactionsLive do
    pipe_through [:browser, :require_authenticated_user]

    live_session :transactions,
      on_mount: [{StygianWeb.UserAuth, :ensure_authenticated_and_mount_character}] do
      live "/transactions", TransactionsLive, :index
      live "/inventory", InventoryLive, :index
      live "/inventory/:id/use", InventoryLive, :use
      live "/inventory/:id/give", InventoryLive, :give
      live "/inventory/:id/throw", InventoryLive, :delete
      live "/organisations/job/selection", OrganisationsJobSelectionLive, :index
      live "/organisations", OrganisationsJobLive, :index
    end
  end

  scope "/guide", StygianWeb.GuideLive do
    pipe_through [:browser]

    live_session :guide do
      live "/", GuideLive
      live "/:action", GuideLive
    end
  end

  scope "/admin", StygianWeb do
    pipe_through [:browser, :require_admin_user]

    get "/redirect/:character_id", CharacterController, :handle_admin_selection

    live_session :admin_dashboard,
      on_mount: [{StygianWeb.UserAuth, :ensure_admin}] do
      live "/", AdminLive.AdminDashboardLive, :index
      live "/npcs", AdminLive.CharacterNpcDashboardLive, :index
      live "/npc/create", AdminLive.CharacterNpcCreationLive, :create

      live "/objects/assign", ObjectLive.Assign, :index

      live "/objects", ObjectLive.Index, :index
      live "/objects/new", ObjectLive.Index, :new
      live "/objects/:id/edit", ObjectLive.Index, :edit

      live "/objects/:id", ObjectLive.Show, :show
      live "/objects/:id/show/edit", ObjectLive.Show, :edit

      live "/object_effects", EffectLive.Index, :index
      live "/object_effects/new", EffectLive.Index, :new
      live "/object_effects/:id/edit", EffectLive.Index, :edit
      live "/object_effects/:object_id", EffectLive.Index, :index

      live "/inventories", AdminLive.InventoryAdminLive, :index

      live "/effects", AdminLive.EffectsListLive, :index

      live "/transactions", AdminLive.TransactionsListLive, :index

      live "/character", AdminLive.CharacterSheetEditLive, :edit

      live "/organisations", OrganisationLive.Index, :index
      live "/organisations/new", OrganisationLive.Index, :new
      live "/organisations/:id/edit", OrganisationLive.Index, :edit

      live "/organisations/:id", OrganisationLive.Show, :show
      live "/organisations/:id/show/edit", OrganisationLive.Show, :edit
    end
  end
end

defmodule StygianWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use StygianWeb, :controller
      use StygianWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(assets fonts images favicon.ico robots.txt)

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: StygianWeb.Layouts]

      import Plug.Conn
      import StygianWeb.Gettext

      unquote(verified_routes())
    end
  end

  def live_view, do: add_live_view(:app)

  def container_live_view, do: add_live_view(:app_container)

  def login_live_view, do: add_live_view(:login)

  def guide_live_view, do: add_live_view(:guide_container)

  defp add_live_view(layout) when is_atom(layout) do
    quote do
      use Phoenix.LiveView,
        layout: {StygianWeb.Layouts, unquote(layout)}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import StygianWeb.CoreComponents
      # Selection component for app entities
      import StygianWeb.EntitiesSelectors
      import StygianWeb.Gettext

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # A collection of helpers for the layout management
      import StygianWeb.GenericLiveViewHelpers

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: StygianWeb.Endpoint,
        router: StygianWeb.Router,
        statics: StygianWeb.static_paths()

      import StygianWeb.CustomVerifiedRoutes
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end

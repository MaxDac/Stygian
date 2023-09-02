defmodule StygianWeb.GuideLive.GuideComponentsLive do
  @moduledoc """
  A series of function components to add to the guide page. 
  """

  use StygianWeb, :html

  import StygianWeb.GuideLive.GuideIntroductionLive
  import StygianWeb.GuideLive.GuideEnvironmentLive
  import StygianWeb.GuideLive.GuideCreationLive
  import StygianWeb.GuideLive.GuideRulesLive

  @doc """
  The menu component. It will receive the menu items from the main live view.
  """
  attr :menu_entries, :list, required: true

  def menu(assigns) do
    ~H"""
    <nav class="bg-transparent md:flex md:justify-center">
      <div class="max-w-screen-xl flex flex-wrap items-center justify-between mx-auto p-1">
        <button
          data-collapse-toggle="navbar-default"
          type="button"
          class="inline-flex items-center p-2 w-10 h-10 justify-center text-sm text-brand rounded-lg md:hidden hover:bg-brand-inactive hover:text-zinc-900 focus:outline-none focus:ring-2 focus:ring-brand"
          aria-controls="navbar-default"
          aria-expanded="false"
        >
          <span class="sr-only">Open main menu</span>
          <svg
            class="w-5 h-5"
            aria-hidden="true"
            xmlns="http://www.w3.org/2000/svg"
            fill="none"
            viewBox="0 0 17 14"
          >
            <path
              stroke="currentColor"
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M1 1h15M1 7h15M1 13h15"
            />
          </svg>
        </button>
        <div class="hidden w-full md:block md:w-auto" id="navbar-default">
          <ul class="font-medium flex flex-col p-4 md:p-0 mt-4 border border-brand rounded-lg md:flex-row md:space-x-8 md:mt-0 md:border-0 bg-transparent">
            <li :for={menu_entry <- @menu_entries}>
              <.menu_item entry={menu_entry} />
            </li>
          </ul>
        </div>
      </div>
    </nav>
    """
  end

  defp menu_item(%{entry: %{active: true}} = assigns) do
    ~H"""
    <.link
      patch={~p"/guide/#{@entry.action}"}
      class="font-typewriter block py-2 pl-3 pr-4 text-zinc-900 bg-brand rounded md:bg-transparent md:text-brand md:p-0"
      aria-current="page"
    >
      <%= @entry.title %>
    </.link>
    """
  end

  defp menu_item(assigns) do
    ~H"""
    <.link
      patch={~p"/guide/#{@entry.action}"}
      class="font-typewriter block py-2 pl-3 pr-4 rounded md:border-0 md:p-0 text-white md:hover:text-brand-inactive hover:bg-brand-inactive hover:text-white md:hover:bg-transparent"
      aria-current="page"
    >
      <%= @entry.title %>
    </.link>
    """
  end

  @doc """
  Constitutes the body of the guide page, it switches between the different sections.
  """
  attr :action, :atom, required: true

  def body(assigns) do
    ~H"""
    <article>
      <.introduction :if={@action == :introduction} />
      <.environment :if={@action == :environment} />
      <.creation :if={@action == :creation} />
      <.rules :if={@action == :rules} />
    </article>
    """
  end
end

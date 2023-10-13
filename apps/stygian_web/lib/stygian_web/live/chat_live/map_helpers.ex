defmodule StygianWeb.ChatLive.MapHelpers do
  @moduledoc """
  Map helpers to show the map locations.
  """

  use StygianWeb, :html

  @doc """
  A function component that renders the map selectors.
  """
  attr :maps, :list, default: []
  attr :base_link, :string, required: true

  def small_screen_map_selector(assigns) do
    ~H"""
    <div :for={map <- @maps} class="text-center">
      <.link navigate={@base_link <> "/#{map.id}"} class="font-berolina text-2xl text-brand">
        <%= map.name %>
      </.link>
    </div>
    """
  end
end

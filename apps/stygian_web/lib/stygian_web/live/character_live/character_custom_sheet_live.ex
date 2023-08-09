defmodule StygianWeb.CharacterLive.CharacterCustomSheetLive do
  @moduledoc """
  This LiveView shows the character custom sheet, free to modify.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Characters

  @impl true
  def mount(_params, _session, %{assigns: %{current_character: %{custom_sheet: custom_sheet}}} = socket) do
    {:ok,
     socket
     |> assign(:custom_sheet, custom_sheet)}
  end

  @impl true
  def mount(%{"character_id" => character_id}, _session, socket) do
    {:ok,
     socket
     |> assign_custom_sheet(character_id)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1>Scheda</.h1>

    <div class="text-center">
      <.link navigate={~p"/character/sheet"} class="font-report text-lg text-brand">
        Torna alla scheda
      </.link>
    </div>

    <div class="space-y-5">
      <%= @custom_sheet %>
    </div>
    """
  end

  defp assign_custom_sheet(socket, character_id) do
    character = Characters.get_character!(character_id)
    assign(socket, :custom_sheet, character.custom_sheet)
  end
end

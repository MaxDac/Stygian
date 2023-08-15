defmodule StygianWeb.CharacterLive.CharacterCustomSheetLive do
  @moduledoc """
  This LiveView shows the character custom sheet, free to modify.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Characters

  @impl true
  def mount(%{"character_id" => character_id}, _session, socket) do
    {:ok,
     socket
     |> assign_character(character_id)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.h1><%= @character.name %></.h1>

    <div class="text-center">
      <.link navigate={~p"/character/sheet/#{@character.id}"} class="font-report text-lg text-brand">
        Torna alla scheda
      </.link>
    </div>

    <div class="space-y-5">
      <%= if @character.custom_sheet do
        raw(Earmark.as_html!(@character.custom_sheet))
      else
        ""
      end %>
    </div>
    """
  end

  defp assign_character(socket, character_id) do
    character = Characters.get_character!(character_id)
    assign(socket, :character, character)
  end
end

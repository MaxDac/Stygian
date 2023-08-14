defmodule StygianWeb.CharacterLive.CharacterSheetStatsLive do
  @moduledoc """
  LiveView for the character sheet stats section.
  """

  use StygianWeb, :live_view

  alias Stygian.Characters

  @impl true
  def mount(%{"character_id" => character_id} = params, _session, socket) do
    {:ok,
     socket
     |> assign_character(character_id)
     |> assign_mode(params)}
  end

  @impl true
  def mount(params, _session, %{assigns: %{current_character: character}} = socket) do
    {:ok,
     socket
     |> assign_character_stats(character)
     |> assign_mode(params)}
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> put_flash(:error, "Non hai accesso a questa pagina.")
     |> push_navigate(~p"/")}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    {:noreply,
     socket
     |> assign_mode(params)}
  end

  defp assign_mode(socket, %{"mode" => "notes"}) do
    assign(socket, :mode, "notes")
  end

  defp assign_mode(socket, _params) do
    assign(socket, :mode, "stats")
  end

  defp assign_character(socket, character_id) do
    case Characters.get_character(character_id) do
      nil ->
        socket
        |> put_flash(:info, "Il personaggio non esiste.")
        |> push_navigate(~p"/")

      character ->
        socket
        |> assign_character_stats(character)
    end
  end

  defp assign_character_stats(socket, character) do
    {attributes, skills} =
      Characters.list_character_attributes_skills(character)

    socket
    |> assign(:attributes, attributes)
    |> assign(:skills, skills)
  end
end

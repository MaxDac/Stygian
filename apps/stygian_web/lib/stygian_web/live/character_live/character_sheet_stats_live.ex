defmodule StygianWeb.CharacterLive.CharacterSheetStatsLive do
  @moduledoc """
  LiveView for the character sheet stats section.
  """

  use StygianWeb, :live_view

  alias Stygian.Characters

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign_character_stats()
     |> assign_mode(params)}
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

  defp assign_character_stats(%{assigns: %{current_character: character}} = socket) do
    character_skills = Characters.list_character_skills(character)

    {attributes, skills} =
      Enum.split_with(character_skills, fn s ->
        Enum.any?(s.skill.skill_types, &(&1.name == "Attribute"))
      end)

    socket
    |> assign(:attributes, attributes)
    |> assign(:skills, skills)
  end

  defp assign_character_stats(socket) do
    assign(socket, :skills, [])
  end
end

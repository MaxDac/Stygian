defmodule StygianWeb.CharacterLive.CharacterSheetStatsLive do
  @moduledoc """
  LiveView for the character sheet stats section.
  """

  use StygianWeb, :live_view

  alias Stygian.Characters

  import StygianWeb.CharacterLive.CharacterSheetStatsBarComponent

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
    |> assign(:character, character)
    |> assign(:attributes, attributes)
    |> assign(:skills, skills)
  end

  defp get_health_percentage(%{health: health, lost_health: lost_health})
       when is_number(health) and is_number(lost_health) do
    Float.ceil((health - lost_health) / health * 100, 0)
  end

  defp get_health_percentage(_), do: 0

  defp get_sanity_percentage(%{sanity: sanity, lost_sanity: lost_sanity})
       when is_number(sanity) and is_number(lost_sanity) do
    Float.ceil((sanity - lost_sanity) / sanity * 100, 0)
  end

  defp get_sanity_percentage(_), do: 0

  defp get_fatigue_percentage(%{fatigue: fatigue})
       when is_number(fatigue) do
    max_fatigue = Characters.get_character_maximum_fatigue()
    Float.ceil(fatigue / max_fatigue * 100, 0)
  end

  defp get_fatigue_percentage(_), do: 0

  defp get_change_sheet_mode_link(current_character, character_id, mode) do
    if is_own_character?(current_character, character_id) do
      ~p"/character/stats?mode=#{if mode == "stats", do: "notes", else: "stats"}"
    else
      ~p"/character/stats/#{character_id}?mode=#{if mode == "stats", do: "notes", else: "stats"}"
    end
  end

  defp get_sheet_link(current_character, character_id) do
    if is_own_character?(current_character, character_id) do
      ~p"/character/sheet"
    else
      ~p"/character/sheet/#{character_id}"
    end
  end

  defp is_own_character?(%{id: current_character_id}, current_character_id), do: true
  defp is_own_character?(_, _), do: false
end

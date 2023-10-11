defmodule StygianWeb.AdminLive.EffectsListLive do
  @moduledoc """
  LiveView for the management effects list page.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Characters

  @impl true
  def mount(_, _, socket) do
    {:ok, assign_active_effects(socket)}
  end

  @impl true
  def handle_event("delete_effect", %{"id" => id}, socket) do
    character_effect = Characters.get_character_effect!(id)

    case Characters.delete_character_effect(character_effect) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Effetto del personaggio correttamente rimosso.")
         |> stream_delete(:effects, %{id: id})}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Errore durante la rimozione dell'effetto del personaggio.")}
    end

    {:noreply, socket}
  end

  defp assign_active_effects(socket) do
    stream(
      socket,
      :effects,
      Characters.list_active_character_effects()
      |> Enum.reduce(%{}, &group_effects_by_character_and_object/2)
      |> Enum.to_list()
      |> Enum.map(&map_grouped_map_to_stream_element/1)
    )
  end

  defp group_effects_by_character_and_object(
         %{id: id, character: character, object: object, effect: effect},
         map
       ) do
    default_value = %{character: character, object: object, effects: [effect]}
    Map.update(map, id, default_value, update_grouping_map_with_new_effect(effect))
  end

  defp update_grouping_map_with_new_effect(effect) do
    fn %{character: c, object: o, effects: effects} ->
      %{character: c, object: o, effects: [effect | effects]}
    end
  end

  defp map_grouped_map_to_stream_element(
         {id, %{character: character, object: object, effects: effects}}
       ) do
    %{
      id: id,
      character: character,
      object: object,
      effects: map_effect_visualisation(effects)
    }
  end

  defp map_effect_visualisation(effects) do
    Enum.map_join(effects, ", ", &"#{&1.skill.name}: #{&1.value}")
  end
end

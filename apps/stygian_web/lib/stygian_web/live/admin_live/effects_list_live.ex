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

  defp assign_active_effects(socket) do
    stream(
      socket, 
      :effects, 
      Characters.list_active_character_effects()
      |> Enum.reduce(%{}, fn %{id: id, character: character, object: object, effect: effect}, acc ->
        Map.update(acc, id, %{character: character, object: object, effects: [effect]}, fn 
          %{character: c, object: o, effects: effects} ->  
            %{character: c, object: o, effects: [effect | effects]}
        end)
      end)
      |> Enum.to_list()
      |> Enum.map(fn {id, %{character: character, object: object, effects: effects}} ->
        %{
          id: id, 
          character: character, 
          object: object, 
          effects: 
            effects
            |> Enum.map(&"#{&1.skill.name}: #{&1.value}")
            |> Enum.join(", ")
        }
      end)
    )
  end
end

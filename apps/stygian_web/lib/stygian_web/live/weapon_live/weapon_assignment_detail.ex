defmodule StygianWeb.WeaponLive.WeaponAssignmentDetail do
  @moduledoc """
  This component allows to assign or remove a weapon from a character.
  """
  
  use StygianWeb, :live_component

  alias Stygian.Weapons

  @impl true
  def update(assigns, socket) do
    {:ok, 
     socket
     |> assign(assigns)
     |> assign_character_weapons(assigns.character_id)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="flex flex-row justify-end mb-5" :if={not is_nil(@character_id)}>
        <.button 
          type="button"
          phx-click={JS.push("add_weapon", value: %{character_id: @character_id})}
        >
          Assegna nuova arma
        </.button>
      </div>

      <.table id="character_weapons" rows={@streams.character_weapons}>
        <:col :let={{_, o}} label="Nome"><%= o.name %></:col>
        <:col :let={{_, o}} label="Danno"><%= o.damage_bonus %></:col>
        <:col :let={{_, o}} label="Costo"><%= o.cost %></:col>
        <:action :let={{_, o}}>
          <.table_link_standalone
            phx-click={JS.push("remove_weapon", value: %{
              weapon_id: o.id,
              character_id: @character_id
            }) |> hide("##{o.id}")}
            data-confirm="Sei sicuro di voler togliere quest'arma al personaggio?"
          >
            Rimuovi arma 
          </.table_link_standalone>
        </:action>
      </.table>
    </div>
    """
  end

  defp assign_character_weapons(socket, nil) do
    stream(socket, :character_weapons, [])
  end

  defp assign_character_weapons(socket, character_id) do
    stream(socket, :character_weapons, Weapons.list_character_weapons(character_id))
  end
end

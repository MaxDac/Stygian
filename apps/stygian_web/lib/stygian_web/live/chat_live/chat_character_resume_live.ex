defmodule StygianWeb.ChatLive.ChatCharacterResumeLive do
  @moduledoc """
  This component will show the character resume.
  If the current user is an admin, it will allow them to edit the character status.
  """

  use StygianWeb, :live_component

  alias Stygian.Characters
  alias Stygian.Characters.CharacterStatusForm

  @impl true
  def update(%{character_id: character_id} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_character(character_id)
     |> assign_form()
     |> assign_is_admin()}
  end

  @impl true
  def handle_event("verify", %{"character_status_form" => params}, socket) do
    {:noreply, 
     socket
     |> assign_form(params)}
  end

  @impl true
  def handle_event("update", %{"character_status_form" => params}, socket) do
    changeset =
      %CharacterStatusForm{}
      |> CharacterStatusForm.changeset(params)

    if changeset.valid? do
      send_form(params)
      {:noreply, assign_form(socket)}
    else
      {:noreply, assign_form(socket, params)}
    end
  end

  defp assign_character(socket, character_id) do
    character = Characters.get_character_slim(character_id)
    assign(socket, :character, character)
  end

  defp assign_form(%{assigns: %{character: %{
    id: character_id,
    health: health,
    sanity: sanity,
    lost_health: lost_health,
    lost_sanity: lost_sanity
  }}} = socket, attrs \\ %{}) do
    form =
      %CharacterStatusForm{
        character_id: character_id,
        health: health - lost_health,
        sanity: sanity - lost_sanity
      }
      |> CharacterStatusForm.changeset(attrs)
      |> to_form()

    assign(socket, :form, form)
  end

  defp assign_is_admin(socket), do: 
    assign(socket, :is_admin, is_admin?(socket))

  defp is_admin?(%{assigns: %{current_user: %{admin: true}}} = _socket), do: true 
  defp is_admin?(_socket), do: false 

  defp send_form(params) do
    send(self(), {:update_status, params})
  end
end

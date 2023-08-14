defmodule StygianWeb.CharacterLive.CharacterSheetLive do
  use StygianWeb, :live_view

  alias Stygian.Characters
  alias StygianWeb.Live.PermissionHelpers

  @impl true
  def mount(%{"character_id" => character_id}, _session, socket) do
    {:ok,
     socket
     |> assign_character(character_id)
     |> assign_confidential_permissions()}
  end

  @impl true
  def mount(_params, _session, socket) do
    case Characters.get_user_character?(socket.assigns.current_user) do
      nil ->
        {:ok,
         socket
         # Removed as it's not an error.
         # |> put_flash(:error, "Devi creare un personaggio prima di accedere alla sua scheda.")
         |> push_navigate(to: ~p"/character/create")}

      %{step: 1} ->
        {:ok,
         socket
         # Removed as it's not an error.
         # |> put_flash(:error, "Devi creare un personaggio prima di accedere alla sua scheda.")
         # |> put_flash(
         #   :error,
         #   "Devi completare la creazione del personaggio prima di accedere alla sua scheda."
         # )
         |> push_navigate(to: ~p"/character/complete")}

      character ->
        {:ok,
         socket
         |> assign(:character, character)
         |> assign_confidential_permissions()}
    end
  end

  defp assign_character(socket, character_id) do
    case Characters.get_character(character_id) do
      nil -> 
        socket
        |> put_flash(:info, "Il personaggio non esiste")
        |> push_navigate(~p"/")

      character ->
        socket
        |> assign(:character, character)
    end
  end

  defp assign_confidential_permissions(%{assigns: %{character: character}} = socket) do
    assign(
      socket,
      :has_access,
      PermissionHelpers.can_access_to_character_confidentials?(socket, character)
    )
  end
end

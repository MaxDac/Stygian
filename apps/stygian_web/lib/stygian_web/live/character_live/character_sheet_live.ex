defmodule StygianWeb.CharacterLive.CharacterSheetLive do
  use StygianWeb, :live_view

  alias Stygian.Characters
  alias StygianWeb.Live.PermissionHelpers

  @impl true
  def mount(%{"character_id" => character_id}, _session, socket) do
    {:ok,
     socket
     |> assign_character(character_id)
     |> assign_confidential_permissions()
     |> assign_modify_permissions()}
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: %{admin: true}}} = socket) do
    # If the user is an admin, redirecting to the PNGs dashboard
    {:ok, push_navigate(socket, to: ~p"/admin/npcs")}
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_character: current_character}} = socket)
      when is_nil(current_character) do
    # If the user does not have a character yet, redirecting to creation
    {:ok,
     socket
     |> push_navigate(to: ~p"/character/create")}
  end

  @impl true
  def mount(_params, _session, %{assigns: %{current_character: %{step: 1}}} = socket) do
    # Character creation at step 1 already, redirecting to character completion
    {:ok,
     socket
     |> push_navigate(to: ~p"/character/complete")}
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign_character()
     |> assign_confidential_permissions()
     |> assign_modify_permissions()}
  end

  defp assign_character(socket, character_id \\ nil)

  defp assign_character(%{assigns: %{current_character: current_character}} = socket, nil) do
    assign(socket, :character, current_character)
  end

  defp assign_character(socket, character_id) do
    case Characters.get_character(character_id) do
      nil ->
        socket
        |> put_flash(:info, "Il personaggio non esiste")
        |> push_navigate(~p"/")

      character ->
        assign(socket, :character, character)
    end
  end

  defp assign_confidential_permissions(%{assigns: %{character: character}} = socket) do
    assign(
      socket,
      :has_access,
      PermissionHelpers.can_access_to_character_confidentials?(socket, character)
    )
  end

  defp assign_modify_permissions(%{assigns: %{character: character}} = socket) do
    assign(
      socket,
      :has_modify_access,
      PermissionHelpers.can_access_to_character_modification?(socket, character)
    )
  end

  defp get_confidential_link(current_character, character_id) do
    if is_own_character?(current_character, character_id) do
      ~p"/character/stats"
    else
      ~p"/character/stats/#{character_id}"
    end
  end

  defp is_own_character?(%{id: current_character_id}, current_character_id), do: true
  defp is_own_character?(_, _), do: false

  defp get_character_age_label(%{age: :young}), do: "Young man"
  defp get_character_age_label(%{age: :adult}), do: "Adult"
  defp get_character_age_label(%{age: :old}), do: "Sir"
end

defmodule StygianWeb.Live.PermissionHelpers do
  @moduledoc """
  Contains helpers to check permissions to access to certain parts of the applications.
  """

  @doc """
  Determines whether the user has access to the confidential information of the character.
  """
  @spec can_access_to_character_confidentials?(
    socket :: Phoenix.LiveView.Socket.t(),
    character :: Stygian.Characters.Character.t()
  ) :: boolean()
  def can_access_to_character_confidentials?(socket, character)
  def can_access_to_character_confidentials?(%{assigns: %{current_user: %{admin: true}}} = _socket, _), do: true
  def can_access_to_character_confidentials?(%{assigns: %{current_character: %{id: character_id}}} = _socket, %{id: character_id}), do: true
  def can_access_to_character_confidentials?(_, _), do: false
end

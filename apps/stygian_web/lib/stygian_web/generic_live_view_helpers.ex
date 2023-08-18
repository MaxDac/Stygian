defmodule StygianWeb.GenericLiveViewHelpers do
  @moduledoc """
  A collection of helpers function common to all the live views, to help dealing with the layouts.
  """

  alias Stygian.Accounts.User
  alias Stygian.Characters.Character

  @spec get_sheet_link_title(current_user :: User.t(), current_character :: Character.t()) :: String.t()
  def get_sheet_link_title(current_user, current_character)
  def get_sheet_link_title(%{admin: true}, _), do: "PNG"
  def get_sheet_link_title(_, character) when not is_nil(character), do: "Scheda"
  def get_sheet_link_title(_, _), do: "Creazione"
end

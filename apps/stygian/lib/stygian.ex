defmodule Stygian do
  @moduledoc """
  Stygian keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @doc """
  Checks whether the parameter in input is a list and whether it is not empty.
  """
  defguard is_non_empty_list(list) when is_list(list) and length(list) > 0

  @doc """
  Determines whether the string is empty or null.
  """
  defguard is_not_null_nor_emtpy(string)
           when not is_nil(string) and is_binary(string) and string != ""

  @doc """
  Tries to extract the integer value from the string. Returns nil if the string is empty or null, or not a number.
  """
  @spec id_from_params(String.t()) :: integer() | nil
  def id_from_params(param) when is_not_null_nor_emtpy(param) do
    String.to_integer(param)
  rescue
    _ -> nil
  end

  def id_from_params(_), do: nil
end

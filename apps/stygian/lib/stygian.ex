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
end

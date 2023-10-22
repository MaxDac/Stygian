defmodule StygianWeb.RestLive.CharacterRestHelpers do
  @moduledoc """
  A collection of helper functions to represent the state in the Character Rest LiveView.
  """

  @doc """
  Returns the total number of slots occupied by the selected actions.
  """
  def get_total_slot_sum(%{assigns: %{rest_action_state: rest_action_state}}) do
    rest_action_state
    |> Enum.map(& &1.slots)
    |> Enum.sum()
  end

  @doc """
  Returns the total number of slots occupied by the selected actions.
  """
  def is_button_disables(socket, max_slots) do
    get_total_slot_sum(socket) == max_slots
  end

  @doc """
  Transforms the selected actions into a data structure that can represent the 
  state of the actions in the resume.
  The data structure will be a list of strings of defined length, that will 
  represent the name of the action for each slot that it occupies, or nil if 
  the slot is empty.
  """
  def get_resume_state(rest_action_state, max_slots) do
    rest_action_state
    |> Enum.reduce([], fn %{name: name, slots: slots}, acc ->
      List.duplicate(name, slots) ++ acc
    end)
    |> pad_list(max_slots)
  end

  defp pad_list(list, length) when length(list) < length, do: pad_list([nil | list], length)
  defp pad_list(list, _), do: Enum.reverse(list)
end

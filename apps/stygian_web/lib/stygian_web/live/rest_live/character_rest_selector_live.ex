defmodule StygianWeb.RestLive.CharacterRestSelectorLive do
  @moduledoc """
  This live component will handle the form to select the activities to perform during the rest.
  """

  use StygianWeb, :live_component

  alias Stygian.Rest
  alias Stygian.Rest.RestActionForm

  import Stygian, only: [is_non_empty_list: 1]
  import StygianWeb.RestLive.CharacterRestComponents
  import StygianWeb.RestLive.CharacterRestHelpers

  @action_description_length 25

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_rest_actions()
     |> assign_rest_action_state()
     |> assign_max_allowed_slots()
     |> assign_selected_action_description()
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"rest_action_form" => %{"rest_action_id" => rest_action_id} = params}, socket) do
    socket = 
      case get_selected_action(socket, rest_action_id) do
        %{description: description} when not is_nil(description) ->
          assign_selected_action_description(socket, description)

        nil ->
          assign_selected_action_description(socket, "")
      end

    {:noreply, assign_form(socket, params)}
  end

  @impl true
  def handle_event("add", %{"rest_action_form" => params}, socket) do
    changeset = 
      %RestActionForm{}
      |> RestActionForm.changeset(params)

    if changeset.valid? do
      {:noreply, assign_rest_action_state(socket, changeset.changes.rest_action_id)}
    else
      {:noreply, assign_form(socket, params)}
    end
  end

  @impl true
  def handle_event("complex_rest", _, %{assigns: %{rest_action_state: actions}} = socket) do
    _ = send_complex_rest(actions)
    {:noreply, socket}
  end

  @impl true
  def handle_event("reset_choice", _, socket) do
    {:noreply, reassign_rest_action_state(socket)}
  end

  defp assign_form(socket, attrs \\ %{}) do
    form =
      %RestActionForm{}
      |> RestActionForm.changeset(attrs)
      |> to_form()

    assign(socket, :form, form)
  end

  defp assign_max_allowed_slots(socket) do
    max_allowed_slots = Rest.get_max_allowed_slots()
    assign(socket, :max_allowed_slots, max_allowed_slots)
  end

  defp assign_rest_actions(socket) do
    assign_async(socket, [:rest_actions, :options], fn ->
      rest_actions = Rest.list_rest_actions()

      {:ok,
        %{
          rest_actions: rest_actions,
          options: Enum.map(rest_actions, &map_action_options/1)
        }
      }
    end)
  end

  defp map_action_options(%{
    id: id,
    name: name,
    health: health,
    sanity: sanity,
    research_points: research_points
  } = _action) do
    health_description = "Salute: #{health}"
    sanity_description = "Sanità mentale: #{sanity}"
    research_points_description = "Punti Ricerca: #{research_points}"

    option_description =
      "#{name} (#{health_description} - #{sanity_description} - #{research_points_description})"

    {option_description, id}
  end

  defp assign_rest_action_state(socket, action_id \\ nil)

  defp assign_rest_action_state(%{assigns: %{
    rest_action_state: rest_action_state,
    max_allowed_slots: max_allowed_slots
  }} = socket, action_id) when not is_nil(action_id) do
    selected_action = get_selected_action(socket, action_id)

    slot_sum = 
      rest_action_state
      |> Enum.map(&(&1.slots))
      |> Enum.sum()

    case {selected_action, slot_sum} do
      {%{slots: slots} = action, slot_sum} when slot_sum + slots <= max_allowed_slots ->
        assign(socket, :rest_action_state, [action | rest_action_state])

      _ ->
        socket
        |> send_notification("Non puoi aggiungere questa azione, non hai sufficienti slot a disposizione.")
    end
  end

  defp assign_rest_action_state(%{assigns: %{rest_action_state: rest_action_state}} = socket, nil) when is_non_empty_list(rest_action_state) do
    assign(socket, :rest_action_state, rest_action_state)
  end
  
  defp assign_rest_action_state(socket, _) do
    assign(socket, :rest_action_state, [])
  end
  
  defp reassign_rest_action_state(socket) do
    assign(socket, :rest_action_state, [])
  end

  defp assign_selected_action_description(socket, description \\ "") do
    assign(socket, :selected_action_description, description)
  end

  defp get_selected_action(_, ""), do: nil

  defp get_selected_action(socket, action_id) when is_binary(action_id) do
    get_selected_action(socket, String.to_integer(action_id))
  end

  defp get_selected_action(%{assigns: %{
    rest_actions: %{ok?: true, result: result}
  }}, action_id) do
    Enum.find(result, &(&1.id == action_id))
  end

  defp get_selected_action(_, _), do: nil

  defp send_notification(socket, message) do
    send(self(), {:notification, message})
    socket
  end

  defp send_complex_rest(actions) do
    send(self(), {:complex_rest, actions})
  end 
end

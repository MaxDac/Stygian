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

  @max_allowed_slots 5

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_rest_actions()
     |> assign_rest_action_state()
     |> assign_max_allowed_slots()
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", %{"rest_action_form" => params}, socket) do
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
  def handle_event("complex_rest", _, socket) do
    IO.inspect(socket.assigns.rest_action_state, label: "passing from complex rest")
    {:noreply, socket}
  end

  defp assign_form(socket, attrs \\ %{}) do
    form =
      %RestActionForm{}
      |> RestActionForm.changeset(attrs)
      |> to_form()

    assign(socket, :form, form)
  end

  defp assign_max_allowed_slots(socket) do
    assign(socket, :max_allowed_slots, @max_allowed_slots)
  end

  defp assign_rest_actions(socket) do
    assign_async(socket, [:rest_actions, :options], fn ->
      rest_actions = Rest.list_rest_actions()

      {:ok,
        %{
          rest_actions: rest_actions,
          options: Enum.map(rest_actions, &{&1.name, &1.id})
        }
      }
    end)
  end

  defp assign_rest_action_state(socket, action_id \\ nil)

  defp assign_rest_action_state(%{assigns: %{
    rest_actions: %{ok?: true, result: result},
    rest_action_state: rest_action_state
  }} = socket, action_id) when not is_nil(action_id) do
    selected_action = 
      Enum.find(result, &(&1.id == action_id))

    slot_sum = 
      rest_action_state
      |> Enum.map(&(&1.slots))
      |> Enum.sum()

    case {selected_action, slot_sum} do
      {%{slots: slots} = action, slot_sum} when slot_sum + slots <= @max_allowed_slots ->
        assign(socket, :rest_action_state, [action | rest_action_state])

      _ ->
        IO.puts "no go - passing"
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

  defp send_notification(socket, message) do
    send(self(), {:notification, message})
    socket
  end
end

defmodule StygianWeb.RestLive.CharacterRestSelectorLive do
  @moduledoc """
  This live component will handle the form to select the activities to perform during the rest.
  """

  use StygianWeb, :live_component

  alias Stygian.Rest
  alias Stygian.Rest.RestActionForm

  import StygianWeb.RestLive.CharacterRestComponents

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_rest_actions()
     |> assign_form()}
  end

  @impl true
  def handle_event("validate", params, socket) do
    IO.inspect params, label: "validate"
    {:noreply, socket |> assign_form(params)}
  end

  @impl true
  def handle_event("add", params, socket) do
    IO.inspect params, label: "add"
    {:noreply, socket |> assign_form(params)}
  end

  defp assign_form(socket, attrs \\ %{}) do
    form = 
      %RestActionForm{}
      |> RestActionForm.changeset(attrs)
      |> to_form()

    assign(socket, :form, form)
  end

  defp assign_rest_actions(socket) do
    assign_async(socket, :rest_actions, fn ->
      {:ok, 
        %{
          rest_actions: 
            Rest.list_rest_actions()
            |> Enum.map(&{&1.name, &1.id})
        }
      }
    end)
  end
end

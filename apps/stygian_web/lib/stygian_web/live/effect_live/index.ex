defmodule StygianWeb.EffectLive.Index do
  @moduledoc """
  The list of object effects.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Objects
  alias Stygian.Objects.Effect

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :object_effects, Objects.list_object_effects())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Effect")
    |> assign(:effect, Objects.get_effect!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Effect")
    |> assign(:effect, %Effect{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Object effects")
    |> assign(:effect, nil)
  end

  @impl true
  def handle_info({StygianWeb.EffectLive.FormComponent, {:saved, effect}}, socket) do
    {:noreply, stream_insert(socket, :object_effects, effect)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    effect = Objects.get_effect!(id)
    {:ok, _} = Objects.delete_effect(effect)

    {:noreply, stream_delete(socket, :object_effects, effect)}
  end
end

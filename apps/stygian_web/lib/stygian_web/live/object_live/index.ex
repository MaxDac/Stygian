defmodule StygianWeb.ObjectLive.Index do
  use StygianWeb, :container_live_view

  alias Stygian.Objects
  alias Stygian.Objects.Object

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :objects, Objects.list_objects())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Object")
    |> assign(:object, Objects.get_object!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Object")
    |> assign(:object, %Object{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Objects")
    |> assign(:object, nil)
  end

  @impl true
  def handle_info({StygianWeb.ObjectLive.FormComponent, {:saved, object}}, socket) do
    {:noreply, stream_insert(socket, :objects, object)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    object = Objects.get_object!(id)
    {:ok, _} = Objects.delete_object(object)

    {:noreply, stream_delete(socket, :objects, object)}
  end
end

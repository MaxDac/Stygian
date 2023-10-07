defmodule StygianWeb.OrganisationLive.Index do
  @moduledoc """
  LiveView for listing organisations.
  """

  use StygianWeb, :container_live_view

  alias Stygian.Organisations
  alias Stygian.Organisations.Organisation

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :organisations, Organisations.list_organisations())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Organisation")
    |> assign(:organisation, Organisations.get_organisation!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Organisation")
    |> assign(:organisation, %Organisation{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Organisations")
    |> assign(:organisation, nil)
  end

  @impl true
  def handle_info({StygianWeb.OrganisationLive.FormComponent, {:saved, organisation}}, socket) do
    {:noreply, stream_insert(socket, :organisations, organisation)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    organisation = Organisations.get_organisation!(id)
    {:ok, _} = Organisations.delete_organisation(organisation)

    {:noreply, stream_delete(socket, :organisations, organisation)}
  end
end

defmodule StygianWeb.TransactionsLive.OrganisationsJobSelectionLive do
  @moduledoc """
  Form to select a job for the character.
  """
  
  use StygianWeb, :container_live_view

  alias Stygian.Organisations

  @impl true
  def mount(_, _, %{assigns: %{current_character: current_character}} = socket) do
    {:ok, 
      socket
      |> check_character_job(current_character.id)
      |> stream(:organisations, Organisations.list_organisations())}
  end

  @impl true
  def handle_event("select_job", %{"id" => job_id}, socket) do
    case Organisations.assign_job_to_character(socket.assigns.current_character.id, job_id) do
      {:ok, _} ->
        socket
        |> put_flash(:info, "Hai scelto un lavoro.")
        |> push_patch(to: ~p"/organisations")
      {:error, _} ->
        socket
        |> put_flash(:error, "Non è stato possibile assegnare il lavoro.")
        |> push_patch(to: ~p"/organisations")
    end
  end

  defp check_character_job(socket, character_id) do
    if Organisations.has_character_organisation?(character_id) do
      socket
      |> put_flash(:info, "Il tuo personaggio ha già un lavoro.")
      |> push_patch(to: ~p"/organisations")
    else
      socket
    end
  end
end

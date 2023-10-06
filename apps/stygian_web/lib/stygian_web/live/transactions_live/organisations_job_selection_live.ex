defmodule StygianWeb.TransactionsLive.OrganisationsJobSelectionLive do
  @moduledoc """
  Form to select a job for the character.
  """
  
  use StygianWeb, :container_live_view

  alias Stygian.Organisations

  @impl true
  def mount(_, _, socket) do
    {:ok, stream(socket, :organisations, Organisations.list_organisations())}
  end
end

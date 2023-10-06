defmodule StygianWeb.TransactionsLive.OrganisationsJobLive do
  @moduledoc """
  Page that shows the current job and allows the character to withdraw the 
  daily money from it.
  """
  
  use StygianWeb, :container_live_view

  @impl true
  def mount(_, _, socket) do
    {:ok, socket}
  end
end

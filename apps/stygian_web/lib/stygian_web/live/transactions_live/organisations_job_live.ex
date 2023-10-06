defmodule StygianWeb.TransactionsLive.OrganisationsJobLive do
  @moduledoc """
  Page that shows the current job and allows the character to withdraw the 
  daily money from it.
  """
  
  use StygianWeb, :container_live_view

  alias Stygian.Organisations

  @impl true
  def mount(_, _, socket) do
    {:ok, 
     socket
     |> assign_character_job()}
  end

  defp assign_character_job(%{assigns: %{current_character: current_character}} = socket) do
    job = Organisations.get_character_organisation(current_character.id)
    assign(socket, :job, job)
  end
end

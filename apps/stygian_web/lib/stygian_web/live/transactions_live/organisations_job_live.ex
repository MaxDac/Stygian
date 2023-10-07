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
     |> check_character_work()
     |> assign_character_withdrawal_status()
     |> assign_character_job()}
  end

  @impl true
  def handle_event("withdraw", _, %{assigns: %{current_character: current_character}} = socket) do
    case Organisations.withdraw_salary(current_character.id) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Hai ritirato il tuo salario giornaliero.")
         |> push_navigate(to: ~p"/organisations")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(:error, "Non è stato possibile ritirare il tuo salario giornaliero.")
         |> push_navigate(to: ~p"/organisations")}
    end
  end

  @impl true
  def handle_event("resign", _, %{assigns: %{current_character: current_character}} = socket) do
    case Organisations.revoke_character_organisation(current_character.id) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Hai correttamente licenziato il personaggio.")
         |> push_navigate(to: ~p"/transactions")}

      {:error, _} ->
        {:noreply,
         socket
         |> put_flash(
           :error,
           "Non è stato possibile licenziare il tuo personaggio dal lavoro attuale."
         )
         |> push_navigate(to: ~p"/organisations")}
    end
  end

  defp check_character_work(%{assigns: %{current_character: current_character}} = socket) do
    if Organisations.has_character_organisation?(current_character.id) do
      socket
    else
      socket
      |> put_flash(:info, "Il personaggio non ha ancora un lavoro.")
      |> push_patch(to: ~p"/organisations/job/selection")
    end
  end

  defp assign_character_withdrawal_status(
         %{assigns: %{current_character: current_character}} = socket
       ) do
    status = Organisations.can_withdraw_salary?(current_character.id)
    assign(socket, :can_withdraw, status)
  end

  defp assign_character_job(%{assigns: %{current_character: current_character}} = socket) do
    job = Organisations.get_character_organisation(current_character.id)
    assign(socket, :job, job)
  end
end

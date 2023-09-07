defmodule StygianWeb.TransactionsLive.TransactionsLive do
  @moduledoc """
  This page allows cigs transactions between characters.
  """

  use StygianWeb, :container_live_view

  alias Ecto.Changeset

  alias Stygian.Characters
  alias Stygian.Transactions
  alias Stygian.Transactions.Transaction

  @impl true
  def mount(_params, _session, %{assigns: %{current_character: current_character}} = socket) when not is_nil(current_character) do
    {:ok, 
     socket
     |> assign_all_characters()
     |> assign_form()}
  end
  
  @impl true
  def mount(_params, _session, socket) do
    {:ok, 
     socket
     |> put_flash(:warning, "Per accedere alle transazioni devi avere un personaggio.")
     |> redirect(to: ~p"/")}
  end

  @impl true
  def handle_event("validate", %{"transaction" => transaction_params}, socket) do
    {:noreply, assign_form(socket, transaction_params)}
  end

  @impl true
  def handle_event("save", %{"transaction" => transaction_params}, socket) do
    case Transactions.perform_transaction(transaction_params) do
      {:ok, result} ->
        IO.inspect(result, label: "Transaction result")
        {:noreply, 
         socket
         |> put_flash(:info, "Transazione effettuata con successo.")
         |> redirect(to: ~p"/transactions")}
      {:error, error} ->
        IO.inspect(error, label: "Transaction error")
        {:noreply, 
         socket
         |> handle_error(error, transaction_params)}
    end
  end

  defp assign_all_characters(%{assigns: %{current_character: %{id: current_character_id}}} = socket) do
    characters =
      Characters.list_characters()
      |> Enum.filter(&(&1.id != current_character_id))

    assign(socket, :characters, characters)
  end

  defp assign_form(%{assigns: %{current_character: %{id: current_character_id}}} = socket, attrs \\ %{}) do
    attrs = Map.put_new(attrs, "sender_id", current_character_id)

    form = 
      %Transaction{}
      |> Transactions.change_transaction(attrs)
      |> to_form()

    assign(socket, :form, form)
  end

  defp handle_error(socket, error, params) when is_binary(error) do
    socket
    |> put_flash(:error, error)
    |> assign_form(params)
  end

  defp handle_error(socket, %Changeset{} = error, _) do
    socket
    |> put_flash(:error, "Errore nella transazione.")
    |> assign(:form, to_form(error))
  end
end
